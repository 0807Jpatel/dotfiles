#!/bin/bash

if pgrep -x "spotify" > /dev/null; then
    i3-msg workspace $1;
else
    spotify;
fi
