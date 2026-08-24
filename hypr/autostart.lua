-- Extra autostart processes.
-- o.launch_on_start("my-service")

-- Launch with an explicit initial workspace. This still uses the same dynamic
-- Omarchy terminal/browser choices as their keyboard shortcuts.
hl.on("hyprland.start", function()
  hl.exec_cmd("omarchy-launch-terminal", { workspace = "1 silent" })
  hl.exec_cmd("omarchy-launch-browser", { workspace = "2 silent" })
  hl.exec_cmd(o.launch("obsidian"), { workspace = "3 silent" })
  hl.exec_cmd(o.launch("chatgpt"), { workspace = "3 silent" })
end)

-- Keep only the main browser (currently Brave) on workspace 2.
-- Other browsers and Chromium web apps remain on the workspace where they launch.
-- Terminals are intentionally unrestricted after the initial workspace 1 launch.
o.window("^(brave-browser|brave-origin)$", { workspace = "2 silent" })
o.window("^(obsidian|md\\.Obsidian|md\\.obsidian\\.Obsidian)$", { workspace = "3 silent" })
o.window("^(ChatGPT|chatgpt|com\\.openai\\.(chat|codex))$", { workspace = "3 silent" })
