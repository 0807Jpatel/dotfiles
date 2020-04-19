#!/bin/bash


function getStatus() {
  echo $(playerctl --player=$1 status)
}

function getMetaString() {
  title=$(playerctl --player=$1 metadata title)
  artist=$(playerctl --player=$1 metadata artist)
  trimTitle=$(echo $title | awk 'length($0) > 35 ? $0=substr($0, 0, 35)"..." : 1')
  echo "$trimTitle - $artist"
}

list=$(playerctl -l 2> /dev/null)
output=""
for l in $list; do
  status=$(getStatus $l)
  if [ "$status" == "Playing" ]; then
    metadata=$(getMetaString $l)
    output=" $metadata"
    break
  elif [ "$status" == "Paused" ]; then
    metadata=$(getMetaString $l)
    output=" $metadata"
  fi
done

echo $output
