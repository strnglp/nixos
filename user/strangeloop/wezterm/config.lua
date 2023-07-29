
local wezterm = require 'wezterm'
local mux = wezterm.mux

function scheme_for_appearance(appearance)
  if appearance:lower():find("dark") then
    return "ModifiedPencilDark"
  else
    return "ModifiedPencilLight"
  end
end

wezterm.on("window-config-reloaded", function(window, pane)
  local overrides = window:get_config_overrides() or {}
  local appearance = wezterm.gui.get_appearance()
  local scheme = scheme_for_appearance(appearance)
  if overrides.color_scheme ~= scheme then
    overrides.color_scheme = scheme
    window:set_config_overrides(overrides)
  end
end)

-- Make a nicely sized centered window on my laptop
wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():set_position(448,156)
  window:gui_window():set_inner_size(1024, 768)
end)

return {
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
  audible_bell = "Disabled",
  hide_tab_bar_if_only_one_tab = true,
  enable_scroll_bar = false,
  window_close_confirmation = "NeverPrompt",
  window_background_opacity = 0.95,
  --window_decorations = "RESIZE",
  font = wezterm.font('JetBrains Mono'),
  font_size = 15,
  xcursor_theme = "Adwaita",

}
