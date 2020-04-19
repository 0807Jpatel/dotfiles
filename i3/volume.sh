#!/bin/bash

sink=$(pactl list short sinks | sed -e 's,^\([0-9][0-9]*\)[^0-9].*,\1,' | tail -n 1)

if [ $1 -eq 0 ]; then
    pactl set-sink-mute $sink toggle
else
    pactl set-sink-volume $sink $1%
fi
