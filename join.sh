#!/bin/sh

set -o errexit
set -xv

APP=iTerm2
INPUT="$(pwd)/capture"
NOW=$(date +"%y%m%d%H%M%S")
OUTPUT="$INPUT/$NOW.mov"
FFMPEG="$(pwd)/ffmpeg"

cd "$INPUT"
cnt=0

# mv to count filenames
for file in *-$APP.jpg; do
  if [ -f "$file" ]; then
    ext=${file##*.}
    printf -v pad "%05d" "$cnt"
    mv "$file" "c${pad}.${ext}"
    cnt=$(( $cnt + 1 ))
  fi
done;

rm c00000.jpg;
for pic in c*.jpg; do
  convert $pic -resize 50% $pic
done;

"$FFMPEG" -r 24 -i c%05d.jpg -b:v 20000k "$OUTPUT"
#rm ./c*.jpg

cd -
