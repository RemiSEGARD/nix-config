#!/bin/sh

sink_index=1
sound_emojis=(󰕿 󰖀 󰕾 )
max_sound=130
mute_color="#707880"

mute_emoji="󰝟"

fifo_file=/tmp/pipewire-control$$.fifo

next_sink_index() {
    sink_index=$(pactl list sinks | awk "/Sink #/{n++} END {print $sink_index % n + 1}")
}

update_sink_index() {
    sink_index=$(pactl list sinks | awk "/Sink #/{n++} END {print $sink_index % (n + 1)}")
    [ "$sink_index" -eq 0 ] && sink_index=1
}

get_sink_nickname() {
    get_current_sink_name
    sink_nick=$(eval "echo \$sink_nick_$(echo ${sink_name} | sed 's/[[:punct:]]/_/g')")
    [ ! -z "$sink_nick" ] && return
    sink_nick=$(pactl list sinks | grep -A1 "Name: $sink_name" |
        sed -n 's/.*Description: \(.*\)/\1/p')
}

get_current_sink_name() {
    update_sink_index
    sink_name=$(pactl list sinks | grep -A2 "Sink #" |
        awk '/Name:/{print $2}' | sed -n "${sink_index}p")
}

get_default_sink_name() {
    sink_name=$(pactl info | awk '/Default Sink:/{print $3}')
}

get_current_sink_mute() {
    sink_mute=$(pactl get-sink-mute "$sink_name" | 
        awk '{ if ($2 == "yes") { print "true" } else { print "false"}}')
}

get_current_sink_sound_level() {
    sink_volume=$(pactl get-sink-volume "$sink_name" | grep -o "[0-9]\+%" | head -n1)
}

get_volume_emoji() {
    get_current_sink_mute
    if "$sink_mute"; then
        volume_emoji="$mute_emoji"
        muted="%{F$mute_color}"
    else
        emoji_index=$((${sink_volume%%%} * ${#sound_emojis[@]} / ($max_sound + 1)))
        volume_emoji=${sound_emojis[$emoji_index]}
        muted=
    fi
}

output() {
    get_current_sink_sound_level 
    get_volume_emoji

    printf "%s %4s %s\n" "$muted$volume_emoji" "$sink_volume" "$sink_nick"
}

make_fifo() {
    [ ! -e "$fifo_file" ] && mkfifo "$fifo_file"
    # If fd 3 is non existant, create it
    ( : >&3 ) 2>/dev/null || exec 3<>"$fifo_file"
    trap "rm $fifo_file" EXIT
    trap "rm $fifo_file; exit 0" SIGTERM
}

listen() {
    make_fifo
    pactl subscribe | {
        while read line; do
            case $line in
                # We don't need to update this much
                *remove*|*new*|*card*|*source*)
                    continue
                    ;;
                *)
                    echo o
            esac
        done
    } >&3 &
}

volume_up() {
    get_current_sink_sound_level
    [ $((${sink_volume%%%} + 5)) -gt $max_sound ] && 
        pactl set-sink-volume "$sink_name" $max_sound% ||
        pactl set-sink-volume "$sink_name" +5%
}

volume_down() {
    pactl set-sink-volume "$sink_name" -5%
}

volume_mute() {
    pactl set-sink-mute "$sink_name" toggle
}

read_input() {
    make_fifo
    get_current_sink_name
    get_sink_nickname

    : &
    while read command; do
        # Wait for the previous command to properly end, it allows read to take
        # its time to read the next command while the previous command executes.
        wait $! 2>/dev/null
        case $command in
        u)
            volume_up &
            ;;
        d)
            volume_down &
            ;;
        m)
            volume_mute &
            ;;
        n)
            next_sink_index
            get_current_sink_name
            get_sink_nickname
            ;;
        o)
            : output
            ;;
        *)
            : echo "Error: unknown input command: `$command`"
            ;;
        esac
        output
    done <&3
}

help() {
    echo "\
Usage: $0 [OPTION...] ACTION [ACTION...]

Options:
    --help                                  Displays this text
    --set-nick <sink>=<nickname>            Changes the nickname to use of the
                                            sink
    --mute-color #<hex>                     Sets the mute color to <hex> 
                                            Defaults to ${mute_color}

Actions:
    output              Prints the volume and the nickname of the sink
    read_input          Creates a fifo at $fifo_file and reads commands from it
    listen              Subscribes to pavucontrol events and adds an 'output'
                        command in the fifo at $fifo_file. Implies 'read_input'.
    volume_up           Increases the volume of the default sink by 5%
    volume_down         Decreases the volume of the default sink by 5%
    volume_mute         Mutes the default sink"
}

while [ $# -ne 0 ]; do
    case "$1" in
    --help)
        help
        exit 0
        ;;
    --mute-color)
        shift
        mute_color="$1"
        ;;
    --set-nick)
        shift
        eval "sink_nick_$(echo "$1" | sed 's/\(.*\)=.*/\1/;s/[[:punct:]]/_/g')"="'$(echo "$1" | awk -F = '{print $2}')'"
        echo "sink_nick_$(echo "$1" | sed 's/\(.*\)=.*/\1/;s/[[:punct:]]/_/g')"="'$(echo "$1" | awk -F = '{print $2}')'"
        ;;
    output)
        get_current_sink_name
        get_sink_nickname

        output
        ;;
    volume_up)
        for pipe in /tmp/pipewire-control*.fifo; do
            echo u > $pipe
        done
        ;;
    volume_down)
        for pipe in /tmp/pipewire-control*.fifo; do
            echo d > $pipe
        done
        ;;
    volume_mute)
        for pipe in /tmp/pipewire-control*.fifo; do
            echo m > $pipe
        done
        ;;
    next_sink)
        for pipe in /tmp/pipewire-control*.fifo; do
            echo n > $pipe
        done
        ;;
    listen)
        listen
        read_input
        ;;
    read_input)
        read_input
        ;;
    *)
        echo Unknown option `$1`
        exit 1
    esac
    shift
done
