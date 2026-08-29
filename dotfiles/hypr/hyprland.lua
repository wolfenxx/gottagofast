------------------
---- MONITORS ----
------------------

hl.monitor({
    output   = "",
    mode     = "1920x1080@120",
    position = "auto",
    scale    = 1,
})


---------------------
---- MY PROGRAMS ----
---------------------

local terminal     = "kitty -e tmux"
local browser      = "brave --url https://google.com"
local fileManager  = "nautilus"
local menu         = "rofi -show drun"
local fullMenu     = "rofi -show run"
local powerMenu    = "wlogout"

local volumeUp     = "wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
local volumeDown   = "wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-"
local toggleMute   = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

local brightnessUp   = "brightnessctl set 5%+"
local brightnessDown = "brightnessctl set 5%-"

local printScreen = 'grim -g "$(slurp)"'


-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd(terminal)
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("waybar")
    hl.exec_cmd("hyprctl keyword monitor Unknown-1,disable")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 5,

        border_size = 2,

        col = {
            active_border   = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        resize_on_border = false,
        allow_tearing    = false,

        layout = "dwindle",
    },

    decoration = {
        rounding = 10,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        blur = {
            enabled  = true,
            size     = 3,
            passes   = 1,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

-- Curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows",         enabled = true, speed = 7,  bezier = "myBezier" })
hl.animation({ leaf = "windowsOut",      enabled = true, speed = 7,  bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border",          enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle",     enabled = true, speed = 8,  bezier = "default" })
hl.animation({ leaf = "fade",            enabled = true, speed = 7,  bezier = "default" })
hl.animation({ leaf = "workspaces",      enabled = true, speed = 6,  bezier = "default" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 6, bezier = "default", style = "slidefadevert -50%" })

hl.config({
    dwindle = {
        -- NOTE: dwindle:pseudotile was dropped -- it's no longer a valid
        -- Hyprland config key as of 0.56 (checked against this build's Lua
        -- stubs), so there's nothing left to carry over from the old conf.
        preserve_split = true,
    },
})

hl.config({
    master = {
        new_status = "master",
    },
})

hl.config({
    ecosystem = {
        no_update_news  = true,
        no_donation_nag = true,
    },
})

hl.config({
    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo   = true,
    },
})


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout = "us",

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = false,
        },
    },
})

-- hl.gesture({
--     fingers   = 3,
--     direction = "horizontal",
--     action    = "workspace",
-- })

hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
-- hl.bind(mainMod .. " + E", hl.dsp.exit()) -- exits Hyprland and logs out user
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(powerMenu))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd(printScreen))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd(fullMenu))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))

-- Move focus with mainMod + vim-style keys
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [1-9]
-- Move active window to a workspace with mainMod + SHIFT + [1-9]
-- Special workspace (scratchpad) with mainMod + ALT + [1-9]
-- Move active window to special workspace with mainMod + SHIFT + ALT + [1-9]
for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i,                 hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. i,         hl.dsp.window.move({ workspace = i }))
    hl.bind(mainMod .. " + ALT + " .. i,           hl.dsp.workspace.toggle_special("sp" .. i))
    hl.bind(mainMod .. " + SHIFT + ALT + " .. i,   hl.dsp.window.move({ workspace = "special:sp" .. i }))
end

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- wireplumber volume controls
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(volumeUp))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(volumeDown))
hl.bind(mainMod .. " + EQUAL",  hl.dsp.exec_cmd(volumeUp))
hl.bind(mainMod .. " + MINUS",  hl.dsp.exec_cmd(volumeDown))
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd(toggleMute))
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd(toggleMute))

-- brightnessctl controls
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd(brightnessUp))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(brightnessDown))

-- toggle fullscreen
hl.bind(mainMod .. " + M", hl.dsp.window.fullscreen())


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

-- NOTE: fullscreen_state / sync_fullscreen aren't in the typed Lua window
-- rule fields (same as suppress_event above), but Hyprland forwards
-- unrecognized keys straight through to the same window-rule engine as
-- hyprlang, using the same value syntax -- verify these three still behave
-- as expected once you're running on this config.
hl.window_rule({
    name  = "chrome-fullscreen",
    match = { class = "(google-chrome)" },

    fullscreen_state = "0 0",
    sync_fullscreen   = 0,
})

hl.window_rule({
    name  = "brave-fullscreen",
    match = { class = "(brave-browser)" },

    fullscreen_state = "0 0",
    sync_fullscreen   = 0,
})

hl.window_rule({
    name  = "webcord-fullscreen",
    match = { class = "(WebCord)" },

    fullscreen_state = "0 2",
    sync_fullscreen   = 0,
})
