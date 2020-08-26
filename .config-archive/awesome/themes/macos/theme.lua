local theme_assets = require("beautiful.theme_assets")
local dpi = require("beautiful.xresources").apply_dpi
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local gears_shape = require("gears.shape")
local wibox = require("wibox")
local awful_widget_clienticon = require("awful.widget.clienticon")

-- inherit xresources theme:
local theme = dofile(themes_path .. "xresources/theme.lua")
theme.font = "Open Sans Regular 10"
theme.bg_systray = "#1d2733" -- doesn't stand out in the background

theme.bg_normal = "#6272a4"
theme.fg_normal = "#fdf6e3"

theme.wibar_bg = "#1d2733"
theme.wibar_fg = "#f8f8f2"

theme.bg_focus = "#282a36"
theme.fg_focus = "#f8f8f2"

theme.bg_urgent = "#f1fa8c"
theme.fg_urgent = "#282a36"

theme.bg_minimize = "#282a3600"
theme.fg_minimize = "#676767"

theme.border_normal = "#00000001"
theme.border_focus = "#ffb86c"
theme.border_marked = "#50fa7b"

theme.border_width = dpi(0)

theme.useless_gap = dpi(5)

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg|shape|shape_border_color|shape_border_width]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg|shape|shape_border_color|shape_border_width]_[focus|urgent|minimized]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]

theme.taglist_bg_empty = "#00000001"
-- theme.taglist_bg_focus = "#bd93f9cc"
theme.taglist_bg_focus = "#ffb86cbb"

theme.taglist_bg_occupied = "#6272a4aa"
theme.taglist_fg_occupied = "#fdf6e3"

theme.taglist_fg_empty = "#f8f8f244"

theme.taglist_fg_focus = "#fdf6e3"

theme.tasklist_fg_normal = theme.wibar_fg
theme.tasklist_bg_normal = "#00000001"
theme.tasklist_fg_focus = "#ffd88c"
theme.tasklist_bg_focus = "#00000001"
theme.tasklist_fg_minimized = theme.wibar_fg
theme.tasklist_bg_minimized = "#00000001"

theme.tasklist_font_focus = "Open Sans 10"

theme.tasklist_spacing = 0

theme.titlebar_font_normal = "Open Sans Bold 10"
theme.titlebar_bg_normal = "#6272a4"
theme.titlebar_fg_normal = "#f8f8f2"

theme.titlebar_font_focus = "Open Sans Bold 10"
theme.titlebar_bg_focus = "#6272a4"
theme.titlebar_fg_focus = "#f8f8f2"

theme.tooltip_fg = "#44475a"
theme.tooltip_bg = "#f8f8f2"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]

theme.menu_border_width = 0
theme.menu_bg_normal = "#181a26"
theme.menu_fg_normal = "#f8f8f2"

theme.menu_height = dpi(28)
theme.menu_width = dpi(150)
theme.menu_submenu_icon = nil
theme.menu_submenu = "▸ "

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
-- theme.bg_widget = "#cc0000"

theme = theme_assets.recolor_layout(theme, theme.wibar_fg)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

theme.taglist_squares_sel = nil
theme.taglist_squares_unsel = nil

theme.wallpaper = "/home/misha/.config/awesome/themes/macos/wallpaper.png"

local icons = '/home/misha/.config/awesome/themes/dracula/icons/'
theme.titlebar_close_button_normal = icons .. "close-unfocused.svg"
theme.titlebar_close_button_focus = icons .. "close-focused.svg"

theme.titlebar_maximized_button_normal_inactive =
    icons .. "maximize-unfocused.svg"
theme.titlebar_maximized_button_focus_inactive = icons .. "maximize-focused.svg"
theme.titlebar_maximized_button_normal_active = icons .. "maximize-focused.svg"
theme.titlebar_maximized_button_focus_active = icons .. "maximize-focused.svg"

theme.titlebar_minimize_button_normal = icons .. "minimize-unfocused.svg"
theme.titlebar_minimize_button_focus = icons .. "minimize-focused.svg"

theme.titlebar_floating_button_normal_inactive = icons .. "tiling-unfocused.svg"
theme.titlebar_floating_button_focus_inactive = icons .. "tiling-focused.svg"
theme.titlebar_floating_button_normal_active = icons .. "floating-unfocused.svg"
theme.titlebar_floating_button_focus_active = icons .. "floating-focused.svg"

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80:foldmethod=marker
