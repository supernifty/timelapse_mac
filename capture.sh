#!/bin/bash

echo "starting..."

set -o errexit

# leave blank for all
#APP=blender
APP=

OUTPUT=$(pwd)/capture
SLEEP=60

mkdir -p "$OUTPUT"

cd "$OUTPUT"

RES_WIDTH=$(/usr/sbin/system_profiler SPDisplaysDataType | grep Resolution)
RES_WIDTH=(${RES_WIDTH:22:4})
RES_WIDTH=$((RES_WIDTH/2))

while true; do
  NOW=$(date +"%y%m%d%H%M%S")
  RUNNING=$(lsappinfo info $(lsappinfo front) | head -1 | sed 's/"\([^"]*\)".*/\1/')

  if [ "$APP" == "" -o "$APP" == "$RUNNING" ]; then
    screencapture -C -t jpg -x "$OUTPUT/$NOW-$RUNNING.jpg"
    echo "captured $OUTPUT/$NOW-$RUNNING.jpg"
    sleep $SLEEP & pid=$!
    wait $pid
  else
    echo "skipping $RUNNING"
    sleep $SLEEP
  fi

done

cd -
