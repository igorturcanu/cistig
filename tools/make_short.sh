#!/usr/bin/env bash
# Build a vertical 1080x1920 Short (default 60 s) from a folder of images and one audio file.
# The images are shown in file-name order with a 1 s crossfade; the audio is trimmed to
# the target length (looped if it is shorter), fades in over 1 s and out over the last 3 s.
#
# Usage:
#   tools/make_short.sh AUDIO_FILE IMAGES_DIR OUTPUT.mp4 [SECONDS]
#
# Example:
#   tools/make_short.sh melody.mp3 images/morning-oasis short.mp4 60
set -euo pipefail

if [ "$#" -lt 3 ]; then
  sed -n '2,11p' "$0" | sed 's/^# \{0,1\}//'
  exit 1
fi

audio=$1; dir=$2; out=$3; total=${4:-60}
x=1  # crossfade length in seconds

[ -f "$audio" ] || { echo "Missing audio file: $audio" >&2; exit 1; }
mapfile -t imgs < <(find "$dir" -maxdepth 1 -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \) | sort)
n=${#imgs[@]}
[ "$n" -ge 2 ] || { echo "Need at least 2 images in $dir (found $n)" >&2; exit 1; }

# every image is shown for d seconds so that n*d - (n-1)*x = total
d=$(awk -v t="$total" -v n="$n" -v x="$x" 'BEGIN{printf "%.3f", (t + (n-1)*x)/n}')

inputs=(); filter=""
for i in "${!imgs[@]}"; do
  inputs+=(-loop 1 -t "$d" -i "${imgs[$i]}")
  filter+="[$i:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,setsar=1,fps=30,format=yuv420p[v$i];"
done

prev="v0"
for ((i = 1; i < n; i++)); do
  off=$(awk -v i="$i" -v d="$d" -v x="$x" 'BEGIN{printf "%.3f", i*(d-x)}')
  filter+="[$prev][v$i]xfade=transition=fade:duration=$x:offset=$off[x$i];"
  prev="x$i"
done
filter=${filter%;}

ffmpeg -v error -y "${inputs[@]}" -stream_loop -1 -i "$audio" \
  -filter_complex "$filter" -map "[$prev]" -map "${n}:a" -t "$total" \
  -af "afade=t=in:d=1,afade=t=out:st=$(awk -v t="$total" 'BEGIN{print t-3}'):d=3" \
  -c:v libx264 -preset medium -crf 20 -pix_fmt yuv420p -c:a aac -b:a 192k -movflags +faststart "$out"

echo "Done: $out ($(ffprobe -v error -show_entries format=duration -of csv=p=0 "$out") s)"
