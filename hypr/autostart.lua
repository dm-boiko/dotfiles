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

-- Keep every subsequently opened terminal/browser/app on its assigned
-- workspace too. Direct class matching is required because workspace is an
-- initial-only rule, while Omarchy's category tags are applied dynamically.
o.window(
  "^(Alacritty|kitty|com\\.mitchellh\\.ghostty|foot|org\\.codeberg\\.dnkl\\.foot|wezterm)$",
  { workspace = "1 silent" }
)
o.window(
  "^((google-)?[cC]hrom(e|ium)|[bB]rave-browser|[mM]icrosoft-edge|Vivaldi-stable|helium|[fF]irefox|zen|librewolf).*$",
  { workspace = "2 silent" }
)
o.window("^(obsidian|md\\.Obsidian)$", { workspace = "3 silent" })
o.window("^(ChatGPT|chatgpt|com\\.openai\\.(chat|codex))$", { workspace = "3 silent" })
