#!/bin/bash
scrot /tmp/screen.png
convert /tmp/screen.png -scale 10% -scale 1000% /tmp/screen.png
convert /tmp/screen.png -draw "fill black fill-opacity 0.4 rectangle 40, 1055, 345, 960" /tmp/screen.png 

song=""

playerctl status &> .spotifyscript
if [ $? == 1 ]; then
    song="Locked"
else
    title=`exec playerctl metadata title`
    artist=`exec playerctl metadata artist`
    song="$title - $artist"
fi

dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Stop
~/.i3lock-color/x86_64-pc-linux-gnu/i3lock \
    -i /tmp/screen.png \
    --blur=3 \
    --clock \
    --datestr "$song" \
    --timestr="%H:%M:%S" \
    --timepos="x+150:h-70" \
    --indpos="x+300:h-70" \
    --radius=25 --ring-width=4 \
    --veriftext="" --wrongtext="" \
    --timecolor="d5c4a1ff" --datecolor="d5c4a1ff" \
    --insidecolor="1d202178" --ringcolor="d5c4a1ff" --line-uses-inside \
    --keyhlcolor="458588ff" --bshlcolor="458588ff" --separatorcolor="1d202178" \
    --insidevercolor="8ec07cff" --ringvercolor="8ec07cff" \
    --insidewrongcolor="cc241dff" --ringwrongcolor="cc241dff" \
rm /tmp/screen.png

