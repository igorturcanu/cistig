#!/usr/bin/env bash
# Asamblează un video lung din clipuri + o melodie (buclă).
# Utilizare: ./build_3h.sh clipuri/ muzica.mp3 iesire.mp4
# Variabile: DURATION (secunde, implicit 10800 = 3 ore), FADE (implicit 1)
set -euo pipefail
CLIPS=${1:?folderul cu clipuri .mp4}; AUDIO=${2:?fisierul audio}; OUT=${3:-video-3h.mp4}
DURATION=${DURATION:-10800}; FADE=${FADE:-1}
TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT
mapfile -t FILES < <(find "$CLIPS" -maxdepth 1 -type f \( -iname '*.mp4' -o -iname '*.mov' \) | sort)
[ ${#FILES[@]} -gt 0 ] || { echo "Nu am gasit clipuri in $CLIPS"; exit 1; }

# 1) fiecare clip -> 1920x1080, 30 fps, fara sunet, cu fade in/out
i=0; : > "$TMP/list.txt"
for f in "${FILES[@]}"; do
  i=$((i+1)); d=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$f")
  st=$(awk -v d="$d" -v fd="$FADE" 'BEGIN{s=d-fd; if(s<0)s=0; print s}')
  ffmpeg -v error -y -i "$f" -an \
    -vf "scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080,fps=30,format=yuv420p,fade=t=in:d=$FADE,fade=t=out:st=$st:d=$FADE" \
    -c:v libx264 -preset medium -crf 20 "$TMP/c$i.mp4"
  echo "file '$TMP/c$i.mp4'" >> "$TMP/list.txt"
done

# 2) segmentul de baza
ffmpeg -v error -y -f concat -safe 0 -i "$TMP/list.txt" -c copy "$TMP/segment.mp4"
SEG=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$TMP/segment.mp4")
echo "Segment de baza: ${SEG}s din ${#FILES[@]} clipuri"

# 3) repeta segmentul pana la DURATION (fara re-encodare)
ffmpeg -v error -y -stream_loop -1 -i "$TMP/segment.mp4" -t "$DURATION" -c copy "$TMP/video.mp4"

# 4) audio in bucla, cu fade-out la final, apoi lipire
ffmpeg -v error -y -stream_loop -1 -i "$AUDIO" -t "$DURATION" \
  -af "afade=t=in:d=3,afade=t=out:st=$(awk -v d="$DURATION" 'BEGIN{print d-8}'):d=8" \
  -c:a aac -b:a 192k "$TMP/audio.m4a"
ffmpeg -v error -y -i "$TMP/video.mp4" -i "$TMP/audio.m4a" -c copy -shortest -movflags +faststart "$OUT"
echo "Gata: $OUT ($(ffprobe -v error -show_entries format=duration -of csv=p=0 "$OUT")s)"
