/**
 * complain — one question when a run finishes: "Did anything about the
 * system annoy you?" A real complaint is appended to
 * ~/.pi/agent/complaints.md. "none" writes nothing.
 *
 * The extension asks and records. The model never runs a command and never
 * sees the log path.
 */

import { appendFileSync, existsSync, mkdirSync } from "node:fs";
import { homedir } from "node:os";
import { basename, dirname, join } from "node:path";

import type { AgentMessage } from "@earendil-works/pi-agent-core";
import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

const LOG = join(homedir(), ".pi", "agent", "complaints.md");
const MARK = "annoyance-check";

type Phase = "idle" | "asking" | "done";

function textOf(message: AgentMessage): string {
	if (message.role !== "assistant" || !Array.isArray(message.content)) return "";
	return message.content
		.filter((part) => part.type === "text")
		.map((part) => part.text)
		.join("\n")
		.trim();
}

/** Text of the assistant reply that follows the latest annoyance question. */
function replyAfterCheck(messages: readonly AgentMessage[]): string {
	let seen = false;
	let text = "";
	for (const message of messages) {
		if (message.role === "custom" && message.customType === MARK) {
			seen = true;
			text = "";
			continue;
		}
		if (seen && message.role === "assistant") text = textOf(message);
	}
	return seen ? text : "";
}

function complaints(reply: string): string[] {
	const lines = reply
		.split("\n")
		.map((line) => line.replace(/^[-*]\s*/, "").trim())
		.filter((line) => line.length > 0 && line.length <= 500 && !/^(none|no|nothing)\.?$/i.test(line));
	return lines.slice(0, 5);
}

function record(ctx: ExtensionContext, lines: string[]): void {
	const now = new Date();
	const pad = (n: number) => String(n).padStart(2, "0");
	const stamp = `${now.getFullYear()}-${pad(now.getMonth() + 1)}-${pad(now.getDate())} ${pad(now.getHours())}:${pad(now.getMinutes())}`;
	const cwd = ctx.sessionManager.getCwd();
	const session = ctx.sessionManager.getSessionId();
	const bullets = lines.map((line) => `- ${stamp} · session ${session} · #${basename(cwd)} · ${line}`);
	mkdirSync(dirname(LOG), { recursive: true });
	const header = existsSync(LOG) ? "" : "# Complaints\n\n";
	appendFileSync(LOG, `${header}${bullets.join("\n")}\n`);
}

export default function (pi: ExtensionAPI) {
	let phase: Phase = "idle";

	pi.on("session_start", () => {
		phase = "idle";
	});

	// A new prompt from you starts a fresh ask. The complaint turn itself is a
	// continuation, so it does not pass through here as a user message.
	pi.on("before_agent_start", (event) => {
		if (event.messageType === "user") phase = "idle";
	});

	pi.on("agent_before_settle", (event, ctx) => {
		if (phase === "asking") {
			phase = "done";
			if (event.outcome !== "completed") return;
			const lines = complaints(replyAfterCheck(event.context.contextMessages));
			if (lines.length > 0) record(ctx, lines);
			return;
		}
		if (phase !== "idle" || event.outcome !== "completed" || !event.context.canContinue) return;
		phase = "asking";
		return {
			entries: [
				...event.entries,
				{
					type: "custom_message" as const,
					customType: MARK,
					display: false,
					content:
						"Did anything about the system annoy you while doing this? " +
						"Reply with the single word none, or one complaint per line. " +
						"One sentence each. No preamble and no tools.",
				},
			],
			continue: true,
		};
	});
}
