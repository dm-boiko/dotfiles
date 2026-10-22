/**
 * usage-footer — slim footer, full stats behind /usage.
 *
 * Footer line 1: cwd (branch) • session on the left (as built-in), model +
 * session cost on the right. The built-in stats strip (tokens, context,
 * cache) is dropped from the footer and moved to `/usage`.
 *
 * Data is computed from session entries, matching the built-in footer (usage
 * entries, assistant/toolResult usage, branch summaries, compactions).
 */

import { isAbsolute, relative, resolve, sep } from "path";

import type { ExtensionAPI, ExtensionContext, Theme } from "@earendil-works/pi-coding-agent";
import type { AssistantMessage, Usage } from "@earendil-works/pi-ai";
import { matchesKey, truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";

/** Mirrors the built-in footer: show cwd as ~/path when it is under $HOME. */
function formatCwdForFooter(cwd: string, home: string | undefined): string {
	if (!home) return cwd;
	const resolvedCwd = resolve(cwd);
	const resolvedHome = resolve(home);
	const rel = relative(resolvedHome, resolvedCwd);
	if (rel === "" || (rel !== ".." && !rel.startsWith(`..${sep}`) && !isAbsolute(rel))) {
		return rel === "" ? "~" : `~${sep}${rel}`;
	}
	return cwd;
}

interface UsageTotals {
	input: number;
	output: number;
	cacheRead: number;
	cacheWrite: number;
	cost: number;
}

interface SessionUsage {
	totals: UsageTotals;
	cacheHitRate: number | undefined;
	cost: number;
}

function addUsage(u: Usage | undefined, t: UsageTotals): void {
	if (!u) return;
	t.input += u.input;
	t.output += u.output;
	t.cacheRead += u.cacheRead;
	t.cacheWrite += u.cacheWrite;
	t.cost += u.cost.total;
}

/** Replicates the built-in footer's per-session usage aggregation. */
function computeUsage(ctx: ExtensionContext): SessionUsage {
	const totals: UsageTotals = { input: 0, output: 0, cacheRead: 0, cacheWrite: 0, cost: 0 };
	let cacheHitRate: number | undefined;
	for (const entry of ctx.sessionManager.getEntries()) {
		if (entry.type === "usage") {
			addUsage(entry.usage, totals);
		} else if (entry.type === "message") {
			if (entry.message.role === "assistant") {
				const usage = (entry.message as AssistantMessage).usage;
				addUsage(usage, totals);
				if (usage) {
					const prompt = usage.input + usage.cacheRead + usage.cacheWrite;
					if (prompt > 0) cacheHitRate = (usage.cacheRead / prompt) * 100;
				}
			} else if (entry.message.role === "toolResult") {
				addUsage((entry.message as { usage?: Usage }).usage, totals);
			}
		} else if ((entry.type === "branch_summary" || entry.type === "compaction") && entry.usage) {
			addUsage(entry.usage, totals);
		}
	}
	return { totals, cacheHitRate, cost: totals.cost };
}

/** Left padding, right truncated when it does not fit. Mirrors the built-in. */
function composeLine(left: string, right: string, width: number): string {
	const leftWidth = visibleWidth(left);
	const rightWidth = visibleWidth(right);
	const minPadding = 2;
	if (leftWidth + minPadding + rightWidth <= width) {
		return left + " ".repeat(width - leftWidth - rightWidth) + right;
	}
	const availableForRight = width - leftWidth - minPadding;
	if (availableForRight > 0) {
		const truncatedRight = truncateToWidth(right, availableForRight, "");
		return left + " ".repeat(width - leftWidth - visibleWidth(truncatedRight)) + truncatedRight;
	}
	return truncateToWidth(left, width, "...");
}

function formatTokens(count: number): string {
	if (count < 1_000) return count.toString();
	if (count < 10_000) return `${(count / 1_000).toFixed(1)}k`;
	if (count < 1_000_000) return `${Math.round(count / 1_000)}k`;
	if (count < 10_000_000) return `${(count / 1_000_000).toFixed(1)}M`;
	return `${Math.round(count / 1_000_000)}M`;
}

export default function (pi: ExtensionAPI) {
	let activeCtx: ExtensionContext | undefined;
	let footerTui: { requestRender(): void } | undefined;

	pi.on("session_start", async (_event, ctx) => {
		activeCtx = ctx;
		if (ctx.mode !== "tui") return;

		ctx.ui.setFooter((tui, theme, footerData) => {
			footerTui = tui;
			return {
				dispose() {
					footerTui = undefined;
				},
				invalidate() {},
				render(width: number): string[] {
					const c = activeCtx;

					// Left, as the built-in line 1: cwd (branch) • session
					let left = formatCwdForFooter(
						c?.cwd ?? "",
						process.env.HOME || process.env.USERPROFILE,
					);
					if (c) {
						const branch = footerData.getGitBranch();
						if (branch) left += ` (${branch})`;
						const sessionName = c.sessionManager.getSessionName();
						if (sessionName) left += ` • ${sessionName}`;
					}

					// Right: model info + session cost (line-2 content, trimmed)
					let right = c?.model?.id || "no-model";
					if (c?.model?.reasoning) {
						const level = c.thinkingLevel || "off";
						right += level === "off" ? " • thinking off" : ` • ${level}`;
					}
					if (footerData.getAvailableProviderCount() > 1 && c?.model) {
						const withProvider = `(${c.model.provider}) ${right}`;
						if (visibleWidth(left) + 2 + visibleWidth(withProvider) <= width) {
							right = withProvider;
						}
					}
					const cost = c ? computeUsage(c).cost : 0;
					right += `  $${cost.toFixed(3)}`;

					const lines = [theme.fg("dim", composeLine(left, right, width))];

					// Extension statuses stay as the built-in line 3.
					const extensionStatuses = footerData.getExtensionStatuses();
					if (extensionStatuses.size > 0) {
						const statusLine = Array.from(extensionStatuses)
							.sort(([a], [b]) => a.localeCompare(b))
							.map(([, text]) => text)
							.join(" ");
						lines.push(truncateToWidth(statusLine, width));
					}
					return lines;
				},
			};
		});
	});

	// Keep the footer current after each turn and across session switches.
	pi.on("turn_end", (_event, ctx) => {
		activeCtx = ctx;
		footerTui?.requestRender();
	});

	pi.registerCommand("usage", {
		description: "Show session usage popup",
		handler: async (_args, ctx) => {
			if (ctx.mode !== "tui") {
				ctx.ui.notify("/usage requires interactive mode", "error");
				return;
			}
			const usage = computeUsage(ctx);
			const contextUsage = ctx.getContextUsage();
			const sessionName = ctx.sessionManager.getSessionName() || ctx.sessionManager.getSessionId();
			const stats = {
				model: ctx.model?.id || "no-model",
				sessionName,
				context: contextUsage,
				totals: usage.totals,
				cacheHitRate: usage.cacheHitRate,
			};
			await ctx.ui.custom<void>(
				(_tui, theme, _kb, done) => new UsagePopup(theme, stats, done),
				{ overlay: true },
			);
		},
	});
}

interface UsagePopupData {
	model: string;
	sessionName: string;
	context: { tokens: number | null; contextWindow: number; percent: number | null } | undefined;
	totals: UsageTotals;
	cacheHitRate: number | undefined;
}

class UsagePopup {
	private readonly theme: Theme;
	private readonly data: UsagePopupData;
	private readonly done: () => void;

	constructor(theme: Theme, data: UsagePopupData, done: () => void) {
		this.theme = theme;
		this.data = data;
		this.done = done;
	}

	invalidate() {}

	handleInput(data: string): void {
		if (
			matchesKey(data, "escape") ||
			matchesKey(data, "ctrl+c") ||
			matchesKey(data, "return") ||
			matchesKey(data, "q")
		) {
			this.done();
		}
	}

	render(width: number): string[] {
		const th = this.theme;
		const w = Math.min(56, Math.max(32, width));
		const innerW = w - 2;
		const lines: string[] = [];

		const pad = (s: string, len: number) => s + " ".repeat(Math.max(0, len - visibleWidth(s)));
		const row = (content: string) =>
			th.fg("border", "│") + pad(content, innerW) + th.fg("border", "│");

		const { totals, cacheHitRate, context, model, sessionName } = this.data;
		const percent =
			context && context.percent !== null ? `${context.percent.toFixed(1)}%` : "?";
		const ctxLine = context
			? `${percent}/${formatTokens(context.contextWindow)}${context.percent !== null && context.percent > 90 ? " ⚠" : ""}`
			: "unknown";

		const ctxRows = [
			row(` ${th.fg("accent", th.bold("Session usage"))}`),
			row(""),
			row(` ${th.fg("dim", "Session")}  ${sessionName}`),
			row(` ${th.fg("dim", "Model")}    ${model}`),
			row(` ${th.fg("dim", "Context")}  ${ctxLine}`),
			row(""),
			row(
				` ${th.fg("dim", "Tokens")}   ${th.bold(`↑${formatTokens(totals.input)}`)}  ${th.bold(`↓${formatTokens(totals.output)}`)}`,
			),
			row(
				` ${th.fg("dim", "Cache")}    R ${formatTokens(totals.cacheRead)}  W ${formatTokens(totals.cacheWrite)}${cacheHitRate !== undefined ? `  hit ${cacheHitRate.toFixed(1)}%` : ""}`,
			),
			row(""),
			row(` ${th.fg("dim", "Cost")}     ${th.bold(`$${totals.cost.toFixed(3)}`)}`),
			row(""),
			row(` ${th.fg("dim", "esc to close")}`),
		];

		lines.push(th.fg("border", `╭${"─".repeat(innerW)}╮`));
		lines.push(...ctxRows);
		lines.push(th.fg("border", `╰${"─".repeat(innerW)}╯`));
		return lines.map((l) => truncateToWidth(l, width));
	}
}