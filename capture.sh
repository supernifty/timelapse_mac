#!/bin/bash

set -o errexit

NOW=$(date +"%y%m%d%H%M%S")

# leave blank for all
#APP_INCLUDE=blender
APP_INCLUDE=Blender
APP_SKIP="^(loginwindow|ScreenSaverEngine)$"

OUTPUT=$(pwd)/capture
SLEEP=15
VERBOSE=0

mkdir -p "$OUTPUT"

echo "$NOW: writing to $OUTPUT with period $SLEEP..."

cd "$OUTPUT"

RES_WIDTH=$(/usr/sbin/system_profiler SPDisplaysDataType | grep Resolution)
RES_WIDTH=(${RES_WIDTH:22:4})
RES_WIDTH=$((RES_WIDTH/2))

while true; do
  NOW=$(date +"%y%m%d%H%M%S")
  #RUNNING=$(lsappinfo info $(lsappinfo front) | head -1 | sed 's/"\([^"]*\)".*/\1/')
  RUNNING=$(lsappinfo | grep "$(lsappinfo front)" | sed 's/^[^ ]* //; s/"\([^"]*\)".*/\1/')

  if [[ "$RUNNING" =~ "$APP_SKIP" ]]; then
    if [[ "$VERBOSE" -eq "1" ]]; then
      echo "$NOW: skipping $RUNNING"
    fi
    sleep $SLEEP
  elif [ "$APP_INCLUDE" == "" -o "$APP_INCLUDE" == "$RUNNING" ]; then
    screencapture -C -t jpg -x "$OUTPUT/$NOW-$RUNNING.jpg"
    echo "$NOW: captured $OUTPUT/$NOW-$RUNNING.jpg"
    sleep $SLEEP & pid=$!
    wait $pid
  else
    if [[ "$VERBOSE" -eq "1" ]]; then
      echo "$NOW: skipping $RUNNING"
    fi
    sleep $SLEEP
  fi

done

cd -
