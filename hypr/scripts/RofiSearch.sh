#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# For Searching via web browsers

# Define the path to the config file
config_file=$HOME/.config/hypr/UserConfigs/01-UserDefaults.lua

# Check if the config file exists
if [[ ! -f "$config_file" ]]; then
    echo "Error: Configuration file not found!"
    exit 1
fi

# 01-UserDefaults.lua returns a table, not hyprlang syntax, so pull
# search_engine out with a real Lua interpreter.
Search_Engine=$(lua - "$config_file" <<'LUA'
hl = { env = function() end }
local d = dofile(arg[1])
io.write(d.search_engine or "")
LUA
)

# Check if $Search_Engine is set correctly
if [[ -z "$Search_Engine" ]]; then
    echo "Error: search_engine is not set in 01-UserDefaults.lua!"
    exit 1
fi

# Rofi theme and message
rofi_theme="$HOME/.config/rofi/config-search.rasi"
msg='‼️ **note** ‼️ search via default web browser'

# Kill Rofi if already running before execution
if pgrep -x "rofi" >/dev/null; then
    pkill rofi
fi

# Open Rofi and pass the selected query to xdg-open for Google search
echo "" | rofi -dmenu -config "$rofi_theme" -mesg "$msg" | xargs -I{} xdg-open $Search_Engine