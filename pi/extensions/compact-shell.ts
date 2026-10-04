/**
 * compact-shell — one-line rendering for the built-in file/shell tools.
 *
 * Collapsed (default): each tool renders as its call line + exactly one
 * result line, e.g.
 *
 *   $ git status && git log -1
 *   ✓ modified: 3 files, branch clean
 *
 *   read src/foo.ts:10-50
 *   41 lines
 *
 * Expanded (ctrl+o): full output, like the built-in renderers.
 *
 * Only rendering is overridden — execution delegates to the built-in tools
 * (same-name registerTool replaces the definition; we spread the original
 * definitions back in).
 */

import type {
	BashToolDetails,
	ExtensionAPI,
	FindToolDetails,
	GrepToolDetails,
	LsToolDetails,
	ReadToolDetails,
	TruncationResult,
} from "@earendil-works/pi-coding-agent";
import {
	createBashToolDefinition,
	createFindToolDefinition,
	createGrepToolDefinition,
	createLsToolDefinition,
	createReadToolDefinition,
} from "@earendil-works/pi-coding-agent";
import { Text } from "@earendil-works/pi-tui";

// ---------------------------------------------------------------- helpers

/** Collapse all whitespace (incl. newlines in multi-line commands) to single spaces. */
function oneLine(s: string): string {
	return s.replace(/\s+/g, " ").trim();
}

/** Truncate keeping head and tail — useful for `cd somewhere && long command`. */
function truncateMiddle(s: string, max: number): string {
	if (s.length <= max) return s;
	const head = Math.ceil((max - 1) * 0.65);
	const tail = Math.max(max - head - 1, 0);
	return s.slice(0, head) + "…" + s.slice(-tail);
}

/** Truncate keeping head only — better for output lines where the start matters. */
function truncateEnd(s: string, max: number): string {
	return s.length <= max ? s : s.slice(0, max - 1) + "…";
}

/** First non-empty text content of a tool result. */
function outputText(result: unknown): string {
	const c = (result as { content?: Array<{ type: string; text?: string }> } | undefined)?.content?.[0];
	return c?.type === "text" ? (c.text ?? "") : "";
}

/** Non-empty lines of a result's text output. */
function outputLines(result: unknown): string[] {
	return outputText(result)
		.split("\n")
		.map((l) => l.trimEnd())
		.filter((l) => l.trim());
}

/** Short "[truncated: …]" suffix for a collapsed result line. */
function truncSuffix(details: { truncation?: TruncationResult } | undefined, theme: any): string {
	return details?.truncation?.truncated ? theme.fg("warning", " [truncated]") : "";
}

/** Full-output view shared by the countable tools (grep/find/ls/read). */
function expandedOutputView(header: string, result: unknown, isError: boolean, theme: any): Text {
	const lines = outputLines(result);
	let text = header + "\n" + (lines.length ? "" : theme.fg("muted", "(no output)"));
	for (const line of lines) {
		text += "\n" + theme.fg("toolOutput", line);
	}
	if (isError) {
		text += "\n" + theme.fg("error", "error");
	}
	return new Text(text, 0, 0);
}

// -------------------------------------------------------------- extension

export default function (pi: ExtensionAPI) {
	const cwd = process.cwd();

	// --- bash: $ command / ✓ last output line ---
	const originalBash = createBashToolDefinition(cwd);
	pi.registerTool({
		...originalBash,
		renderShell: "self",

		renderCall(args, theme, _context) {
			let text = theme.fg("toolTitle", theme.bold("$ "));
			const cmd = args?.command ? truncateMiddle(oneLine(args.command), 140) : "…";
			text += theme.fg("accent", cmd);
			if (args?.timeout) {
				text += theme.fg("dim", ` (timeout: ${args.timeout}s)`);
			}
			return new Text(text, 0, 0);
		},

		renderResult(result, { expanded, isPartial }, theme, _context) {
			const details = result?.details as BashToolDetails | undefined;
			const output = outputText(result);
			const structured = (result as { structuredContent?: { exit_code?: number } } | undefined)?.structuredContent;
			const exitMatch = output.match(/Command exited with code (\d+)/) ?? output.match(/exit code: (\d+)/);
			const exitCode = structured?.exit_code ?? (exitMatch ? parseInt(exitMatch[1], 10) : 0);
			const isError = result?.isError === true;

			// While streaming, show the freshest line as a live preview.
			if (isPartial) {
				const lines = output
					.split("\n")
					.map((l) => l.trimEnd())
					.filter((l) => l.trim() && !/^\[Showing (last |lines )/.test(l.trim()));
				const line = lines[lines.length - 1] ?? "";
				const text =
					theme.fg("warning", "⏳ ") + (line ? theme.fg("toolOutput", truncateEnd(line, 140)) : theme.fg("dim", "running…"));
				return new Text(text, 0, 0);
			}

			if (expanded) {
				let text = theme.fg("toolTitle", theme.bold("$ ")) + theme.fg("accent", oneLine(_context.args?.command ?? ""));
				text += "\n" + (output ? theme.fg("toolOutput", output) : theme.fg("muted", "(no output)"));
				if (isError) text += "\n" + theme.fg("error", `exit ${exitCode}`);
				text += truncSuffix(details, theme);
				return new Text(text, 0, 0);
			}

			// Collapsed: one line — status + last meaningful output line.
			const envelope = /^\[Showing (last |lines )|^Command (exited with code \d+$|aborted$|timed out after \d+ seconds$)/;
			const lines = output.split("\n").map((l) => l.trim()).filter((l) => l && !envelope.test(l));
			const line = lines[lines.length - 1] ?? "";
			const status = isError ? theme.fg("error", `✗ exit ${exitCode} · `) : theme.fg("success", "✓ ");
			const body = line ? theme.fg("toolOutput", truncateEnd(line, 120)) : theme.fg("muted", "(no output)");
			return new Text(status + body + truncSuffix(details, theme), 0, 0);
		},
	});

	// --- read: read path:offset-limit / N lines ---
	const originalRead = createReadToolDefinition(cwd);
	pi.registerTool({
		...originalRead,
		renderShell: "self",

		renderCall(args, theme, _context) {
			const path = args?.path ?? "…";
			let text = theme.fg("toolTitle", theme.bold("read ")) + theme.fg("accent", oneLine(path));
			const startLine = args?.offset;
			if (startLine != null || args?.limit != null) {
				const endLine = args?.limit != null ? (startLine ?? 1) + args.limit - 1 : "";
				text += theme.fg("dim", `:${startLine ?? 1}${endLine ? `-${endLine}` : ""}`);
			}
			return new Text(text, 0, 0);
		},

		renderResult(result, { expanded, isPartial }, theme, _context) {
			const details = result?.details as ReadToolDetails | undefined;
			const isError = result?.isError === true;

			if (isPartial) return new Text(theme.fg("warning", "⏳ reading…"), 0, 0);

			const count = outputLines(result).length;
			if (expanded) {
				return expandedOutputView(theme.fg("toolTitle", theme.bold("read")), result, isError, theme);
			}
			if (isError) {
				const first = outputLines(result)[0] ?? "error";
				return new Text(theme.fg("error", `✗ ${truncateEnd(oneLine(first), 120)}`), 0, 0);
			}
			return new Text(theme.fg("success", `${count} lines`) + truncSuffix(details, theme), 0, 0);
		},
	});

	// --- grep: grep /pattern/ in path (glob) / N matches ---
	const originalGrep = createGrepToolDefinition(cwd);
	pi.registerTool({
		...originalGrep,
		renderShell: "self",

		renderCall(args, theme, _context) {
			let text =
				theme.fg("toolTitle", theme.bold("grep ")) +
				theme.fg("accent", `/${oneLine(args?.pattern ?? "")}/`) +
				theme.fg("toolOutput", ` in ${args?.path ? oneLine(args.path) : "."}`);
			if (args?.glob) text += theme.fg("dim", ` (${args.glob})`);
			return new Text(text, 0, 0);
		},

		renderResult(result, { expanded, isPartial }, theme, _context) {
			const details = result?.details as GrepToolDetails | undefined;
			const isError = result?.isError === true;

			if (isPartial) return new Text(theme.fg("warning", "⏳ searching…"), 0, 0);

			const count = outputLines(result).length;
			if (expanded) {
				return expandedOutputView(
					theme.fg("toolTitle", theme.bold("grep ")) + theme.fg("accent", `/${oneLine(_context.args?.pattern ?? "")}/`),
					result,
					isError,
					theme,
				);
			}
			if (isError) {
				const first = outputLines(result)[0] ?? "error";
				return new Text(theme.fg("error", `✗ ${truncateEnd(oneLine(first), 120)}`), 0, 0);
			}
			return new Text(theme.fg("success", `${count} matches`) + truncSuffix(details, theme), 0, 0);
		},
	});

	// --- find: find pattern in path / N results ---
	const originalFind = createFindToolDefinition(cwd);
	pi.registerTool({
		...originalFind,
		renderShell: "self",

		renderCall(args, theme, _context) {
			const text =
				theme.fg("toolTitle", theme.bold("find ")) +
				theme.fg("accent", oneLine(args?.pattern ?? "")) +
				theme.fg("toolOutput", ` in ${args?.path ? oneLine(args.path) : "."}`);
			return new Text(text, 0, 0);
		},

		renderResult(result, { expanded, isPartial }, theme, _context) {
			const details = result?.details as FindToolDetails | undefined;
			const isError = result?.isError === true;

			if (isPartial) return new Text(theme.fg("warning", "⏳ finding…"), 0, 0);

			const count = outputLines(result).length;
			if (expanded) {
				return expandedOutputView(
					theme.fg("toolTitle", theme.bold("find ")) + theme.fg("accent", oneLine(_context.args?.pattern ?? "")), 
					result,
					isError,
					theme,
				);
			}
			if (isError) {
				const first = outputLines(result)[0] ?? "error";
				return new Text(theme.fg("error", `✗ ${truncateEnd(oneLine(first), 120)}`), 0, 0);
			}
			return new Text(theme.fg("success", `${count} results`) + truncSuffix(details, theme), 0, 0);
		},
	});

	// --- ls: ls path / N entries ---
	const originalLs = createLsToolDefinition(cwd);
	pi.registerTool({
		...originalLs,
		renderShell: "self",

		renderCall(args, theme, _context) {
			let text = theme.fg("toolTitle", theme.bold("ls ")) + theme.fg("accent", args?.path ? oneLine(args.path) : ".");
			if (args?.limit !== undefined) text += theme.fg("dim", ` (limit ${args.limit})`);
			return new Text(text, 0, 0);
		},

		renderResult(result, { expanded, isPartial }, theme, _context) {
			const details = result?.details as LsToolDetails | undefined;
			const isError = result?.isError === true;

			if (isPartial) return new Text(theme.fg("warning", "⏳ listing…"), 0, 0);

			const count = outputLines(result).length;
			if (expanded) {
				return expandedOutputView(theme.fg("toolTitle", theme.bold("ls")), result, isError, theme);
			}
			if (isError) {
				const first = outputLines(result)[0] ?? "error";
				return new Text(theme.fg("error", `✗ ${truncateEnd(oneLine(first), 120)}`), 0, 0);
			}
			return new Text(theme.fg("success", `${count} entries`) + truncSuffix(details, theme), 0, 0);
		},
	});
}
