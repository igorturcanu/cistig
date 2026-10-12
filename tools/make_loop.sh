#!/usr/bin/env bash
# Join several tracks end to end with crossfades and loop them to a target length.
#
# Usage:
#   tools/make_loop.sh OUTPUT.mp3 DURATION_SECONDS CROSSFADE_SECONDS TRACK1 TRACK2 [TRACK3 ...]
#
# Example (3 hours, 8 s crossfade):
#   tools/make_loop.sh rain_3h.mp3 10800 8 a.mp3 b.mp3 c.mp3
#
# The tracks are crossfaded in the given order, the end of the last track is
# crossfaded back into the start of the first one, so the loop has no audible
# seam. The result fades in over 3 s and fades out over the last 20 s.
set -euo pipefail

if [ "$#" -lt 5 ]; then
  sed -n '2,12p' "$0" | sed 's/^# \{0,1\}//'
  exit 1
fi

out=$1; dur=$2; cf=$3; shift 3
tracks=("$@")
n=${#tracks[@]}
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

for t in "${tracks[@]}"; do
  [ -f "$t" ] || { echo "Missing file: $t" >&2; exit 1; }
  len=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$t")
  awk -v l="$len" -v c="$cf" 'BEGIN{exit !(l > 2*c + 1)}' \
    || { echo "Track too short for a ${cf}s crossfade: $t" >&2; exit 1; }
done

# 1) crossfade the tracks into one chain
inputs=(); filter=""
for i in "${!tracks[@]}"; do
  inputs+=(-i "${tracks[$i]}")
  filter+="[$i:a]aresample=44100,aformat=sample_fmts=fltp:channel_layouts=stereo[s$i];"
done
prev="s0"
for ((i = 1; i < n; i++)); do
  filter+="[$prev][s$i]acrossfade=d=$cf:c1=tri:c2=tri[a$i];"
  prev="a$i"
done
filter=${filter%;}
ffmpeg -v error -y "${inputs[@]}" -filter_complex "$filter" -map "[$prev]" "$tmp/chain.wav"

# 2) make the chain loop without a seam (tail fades into head)
len=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$tmp/chain.wav")
ffmpeg -v error -y -i "$tmp/chain.wav" -filter_complex "
  [0:a]asplit=3[h][m][t];
  [h]atrim=0:$cf,asetpts=PTS-STARTPTS[head];
  [t]atrim=start=$(awk -v l="$len" -v c="$cf" 'BEGIN{printf "%.3f", l-c}'),asetpts=PTS-STARTPTS[tail];
  [m]atrim=start=$cf:end=$(awk -v l="$len" -v c="$cf" 'BEGIN{printf "%.3f", l-c}'),asetpts=PTS-STARTPTS[mid];
  [tail][head]acrossfade=d=$cf:c1=tri:c2=tri[blend];
  [blend][mid]concat=n=2:v=0:a=1[cycle]" -map "[cycle]" "$tmp/cycle.wav"

# 3) repeat the cycle up to the target length
ffmpeg -v error -y -stream_loop -1 -i "$tmp/cycle.wav" -t "$dur" \
  -af "afade=t=in:d=3,afade=t=out:st=$(awk -v d="$dur" 'BEGIN{print d-20}'):d=20" \
  -b:a 192k "$out"

echo "Done: $out ($(ffprobe -v error -show_entries format=duration -of csv=p=0 "$out") s)"
