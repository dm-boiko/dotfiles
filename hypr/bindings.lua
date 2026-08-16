-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Application bindings from dotfiles
o.bind("SUPER + B", "Browser", { omarchy = "browser" })
-- o.bind("SUPER + Z", "Browser", { omarchy = "browser" })

-- Unbind default SUPER + F (was: Full screen)
hl.unbind("SUPER + F")
o.bind("SUPER + F", "File manager", { launch = "nautilus --new-window" })

-- Close window with SUPER + Q (SUPER + W is now Universal close tab)
o.bind("SUPER + Q", "Close active window", hl.dsp.window.close())

-- Universal tab shortcuts (Browser vs Terminal)
local function send_shortcut_once(mods, key)
  return function()
    hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "down" }))

    hl.timer(function()
      hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "up" }))
    end, { timeout = 50, type = "oneshot" })
  end
end

local function active_window_is_terminal()
  local window = hl.get_active_window()
  if not window then
    return false
  end

  for _, tag in ipairs(window.tags or {}) do
    if tag:gsub("%*$", "") == "terminal" then
      return true
    end
  end

  return false
end

local function universal_tab_shortcut(default_mods, default_key, terminal_mods, terminal_key)
  return function()
    if active_window_is_terminal() then
      send_shortcut_once(terminal_mods, terminal_key)()
    else
      send_shortcut_once(default_mods, default_key)()
    end
  end
end

-- Unbind default SUPER + T (was: Toggle window floating/tiling)
hl.unbind("SUPER + T")
o.bind("SUPER + T", "Universal new tab", universal_tab_shortcut("CTRL", "T", "CTRL SHIFT", "T"))
o.bind("SUPER + SHIFT + T", "Toggle window floating/tiling", hl.dsp.window.float({ action = "toggle" }))

-- Unbind default SUPER + W (was: Close window)
hl.unbind("SUPER + W")
o.bind("SUPER + W", "Universal close tab", universal_tab_shortcut("CTRL", "W", "CTRL SHIFT", "W"))

-- Fullscreen toggles
o.bind("SHIFT + F11", "Force full screen", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
o.bind("ALT + F11", "Full width", hl.dsp.window.fullscreen({ mode = "maximized" }))
