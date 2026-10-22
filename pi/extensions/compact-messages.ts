/**
 * Compact tool rows using public extension APIs. Execution stays unchanged.
 * Native user/assistant padding and timestamps have no renderer API.
 * ponytail: Pi adds a blank line before each tool; removing it needs a core API.
 */
import { isAbsolute, relative, resolve } from "node:path";
import type { AgentMessage } from "@earendil-works/pi-agent-core";
import type {
	AgentToolResult,
	EditToolDetails,
	ExtensionAPI,
	ExtensionContext,
	ToolRenderContext,
} from "@earendil-works/pi-coding-agent";
import { renderDiff } from "@earendil-works/pi-coding-agent";
import { Text, truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";

const TOOL_LABELS: Record<string, string> = {
	read: "Explored",
	grep: "Searched",
	find: "Found",
	ls: "Listed",
	bash: "Ran",
	powershell: "Ran",
	edit: "Edit",
	write: "Write",
};
const TIMESTAMP_GAP = 2;
const MIN_BODY_COLUMNS = 12;
const timeFormat = new Intl.DateTimeFormat("en-US", { hour: "numeric", minute: "2-digit" });
const emptyComponent = { render: () => [], invalidate() {} };

type ResultDetails = Partial<EditToolDetails> & { truncation?: { truncated?: boolean } };
type Result = AgentToolResult<ResultDetails | undefined>;
type RowContext = ToolRenderContext<{ compactMessageResult?: Result }>;

function oneLine(value: unknown): string {
	return typeof value === "string" ? value.replace(/\s+/g, " ").trim() : "";
}

function displayPath(value: unknown, cwd: string): string {
	if (typeof value !== "string" || !value) return "…";
	if (!isAbsolute(value)) return oneLine(value);
	const short = relative(cwd, value);
	return oneLine(short && !isAbsolute(short) && !short.startsWith("..") ? short : value);
}

function callDescription(tool: string, args: Record<string, unknown>, cwd: string): string {
	if (tool === "bash" || tool === "powershell") return oneLine(args.command) || "…";
	const path = displayPath(args.path ?? (tool === "grep" || tool === "find" || tool === "ls" ? "." : undefined), cwd);
	if (tool === "grep") return `/${oneLine(args.pattern)}/ in ${path}${args.glob ? ` (${oneLine(args.glob)})` : ""}`;
	if (tool === "find") return `${oneLine(args.pattern)} in ${path}`;
	if (tool === "read" && (args.offset != null || args.limit != null)) {
		const start = typeof args.offset === "number" ? args.offset : 1;
		const end = typeof args.limit === "number" ? `-${start + args.limit - 1}` : "";
		return `${path}:${start}${end}`;
	}
	return path;
}

function textOutput(result: Result): string {
	return result.content.filter((block) => block.type === "text").map((block) => block.text).join("\n");
}

export default function (pi: ExtensionAPI) {
	// Use recorded call-request times, not render times, including after resume.
	const timestamps = new Map<string, string>();
	function rememberTime(message: AgentMessage) {
		if (message.role === "assistant") {
			for (const block of message.content) {
				if (block.type === "toolCall") timestamps.set(block.id, timeFormat.format(message.timestamp));
			}
		} else if (message.role === "toolResult" && !timestamps.has(message.toolCallId)) {
			timestamps.set(message.toolCallId, timeFormat.format(message.timestamp));
		}
	}
	function rebuildTimes(_event: unknown, ctx: ExtensionContext) {
		timestamps.clear();
		for (const entry of ctx.sessionManager.getBranch()) {
			if (entry.type === "message") rememberTime(entry.message);
		}
	}
	pi.on("session_start", rebuildTimes);
	pi.on("session_tree", rebuildTimes);
	pi.on("message_update", (event) => rememberTime(event.message));
	pi.on("message_end", (event) => rememberTime(event.message));

	pi.registerToolRenderer((toolName, next) => {
		const label = TOOL_LABELS[toolName];
		if (!label) return next();
		return {
			renderShell: "self",
			renderCall(args, theme, context: RowContext) {
				return {
					invalidate() {},
					render(width: number): string[] {
						if (width <= 0) return [];
						const padding = Math.min(context.outputPad, Math.floor((width - 1) / 2));
						const innerWidth = width - padding * 2;
						const result = context.state.compactMessageResult;
						const pending = context.isPartial;
						const color = context.isError ? "error" : pending ? "warning" : "success";
						const marker = context.isError ? "×" : pending ? "◇" : "◆";
						let body = theme.fg(color, marker) + " " + theme.fg("muted", theme.bold(label));
						// Keep the failure reason visible before potentially long arguments.
						if (context.isError && result) {
							body += " " + theme.fg("error", oneLine(textOutput(result)) || "failed");
						}
						body += " " + theme.fg("dim", callDescription(toolName, args, context.cwd));
						if (!pending && !context.isError && toolName === "edit" && result?.details?.diff) {
							const lines = result.details.diff.split("\n");
							const added = lines.filter((line) => line.startsWith("+")).length;
							const removed = lines.filter((line) => line.startsWith("-")).length;
							body += " " + theme.fg("success", `+${added}`) + "/" + theme.fg("error", `-${removed}`);
						}
						if (result?.details?.truncation?.truncated) body += theme.fg("warning", " [truncated]");
						const time = timestamps.get(context.toolCallId) ?? "";
						const rightWidth = visibleWidth(time);
						let line: string;
						if (time && innerWidth >= MIN_BODY_COLUMNS + TIMESTAMP_GAP + rightWidth) {
							const left = truncateToWidth(body, innerWidth - TIMESTAMP_GAP - rightWidth);
							line = left + " ".repeat(innerWidth - visibleWidth(left) - rightWidth) + theme.fg("dim", time);
						} else {
							line = truncateToWidth(body, innerWidth);
						}
						return [" ".repeat(padding) + line + " ".repeat(padding)];
					},
				};
			},
			renderResult(result: Result, { expanded }, theme, context: RowContext) {
				context.state.compactMessageResult = result;
				if (!expanded) return emptyComponent;
				let output = textOutput(result);
				if (toolName === "edit" && !context.isError && result.details?.diff) {
					output = renderDiff(result.details.diff, { filePath: resolve(context.cwd, context.args.path) });
				} else {
					if (toolName === "write" && typeof context.args.content === "string") {
						output = context.args.content + "\n" + output;
					}
					output = theme.fg(context.isError ? "error" : "toolOutput", output);
				}
				return output ? new Text(output, context.outputPad, 0) : emptyComponent;
			},
		};
	});
}
