#!/bin/sh

shutdown="⏻"
hibernate="󰤄"
lock=""
logout="󰍃"
reboot="󰜉"

yes="✔"
no="🗙"

uptime="$(uptime | sed -e 's/^.*up *\([^,]*\),.*$/\1/g;s/ \+/ /g')"

run_rofi() {
    rofi \
        -dmenu \
        -theme ~/.config/rofi/themes/power-style.rasi \
        -p "Uptime: $uptime" \
        -mesg "Uptime: $uptime"
}

confirm_rofi() {
    rofi \
        -dmenu \
        -theme ~/.config/rofi/themes/power-style.rasi \
        -theme-str 'listview {columns: 2; lines: 1;}'
}

confirm() {
    choice=$(echo -e "$yes\n$no" | confirm_rofi)
    case "$choice" in
        "$yes")
            $@
            ;;
        "$no")
            return
            ;;
        *)
            echo An error occured 1>&2
    esac

}

choice=$(echo -e "$shutdown\n$lock\n$hibernate\n$reboot\n$logout" | run_rofi)

case "$choice" in
    "$shutdown")
        confirm systemctl shutdown
        ;;
    "$hibernate")
        systemctl hibernate
        ;;
    "$lock")
        echo Locking
        i3lock-fancy-rapid 5 5
        ;;
    "$logout")
        confirm i3-msg exit
        ;;
    "$reboot")
        confirm systemctl reboot
        ;;
    *)
        echo An errror occured 1>&2
esac
