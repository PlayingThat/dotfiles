#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# for rainbow borders animation

function random_hex() {
    random_hex=("\"0xff$(openssl rand -hex 3)\"")
    echo $random_hex
}

# rainbow colors only for active window
hyprctl eval "hl.config({ general = { col = { active_border = { colors = { $(random_hex), $(random_hex), $(random_hex), $(random_hex), $(random_hex), $(random_hex), $(random_hex), $(random_hex), $(random_hex), $(random_hex) }, angle = 270 } } } })"

# rainbow colors for inactive window (uncomment to take effect)
#hyprctl eval "hl.config({ general = { col = { inactive_border = { colors = { $(random_hex), $(random_hex), $(random_hex), $(random_hex), $(random_hex), $(random_hex), $(random_hex), $(random_hex), $(random_hex), $(random_hex) }, angle = 270 } } } })"