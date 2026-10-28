#!/usr/bin/env bash
# Asamblează un video lung din clipuri + o melodie (buclă).
# Utilizare: ./build_3h.sh clipuri/ muzica.mp3 iesire.mp4
# AUDIO poate fi un fisier sau un folder cu mai multe melodii (se pun una dupa alta).
# Variabile: DURATION (secunde, implicit 10800 = 3 ore), FADE (implicit 1),
#            IMGDUR (secunde per imagine .jpg/.png, implicit 12),
#            SLOW (implicit 1; 2 = clipurile merg de 2 ori mai incet, mai lungi)
set -euo pipefail
CLIPS=${1:?folderul cu clipuri .mp4}; AUDIO=${2:?fisierul audio}; OUT=${3:-video-3h.mp4}
DURATION=${DURATION:-10800}; FADE=${FADE:-1}; SLOW=${SLOW:-1}
TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT
mapfile -t FILES < <(find "$CLIPS" -maxdepth 1 -type f \( -iname '*.mp4' -o -iname '*.mov' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) | sort)
[ ${#FILES[@]} -gt 0 ] || { echo "Nu am gasit clipuri in $CLIPS"; exit 1; }

# 1) fiecare clip -> 1920x1080, 30 fps, fara sunet, cu fade in/out
i=0; : > "$TMP/list.txt"
IMGDUR=${IMGDUR:-12}   # secunde per imagine (pentru .jpg/.png)
for f in "${FILES[@]}"; do
  i=$((i+1))
  case "${f,,}" in
    *.jpg|*.jpeg|*.png)
      # imagine -> clip cu zoom lent (alternativ in/out)
      fr=$((IMGDUR*30)); st=$(awk -v d="$IMGDUR" -v fd="$FADE" 'BEGIN{print d-fd}')
      if [ $((i%2)) -eq 0 ]; then Z="1.15-0.15*on/$fr"; else Z="1+0.15*on/$fr"; fi
      ffmpeg -nostdin -v error -y -loop 1 -framerate 30 -t "$IMGDUR" -i "$f" \
        -vf "scale=3840:2160:force_original_aspect_ratio=increase,crop=3840:2160,zoompan=z='$Z':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=1:s=1920x1080:fps=30,format=yuv420p,fade=t=in:d=$FADE,fade=t=out:st=$st:d=$FADE" \
        -c:v libx264 -preset medium -crf 20 "$TMP/c$i.mp4" ;;
    *)
      d=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$f" | awk -v k="$SLOW" '{print $1*k}')
      st=$(awk -v d="$d" -v fd="$FADE" 'BEGIN{s=d-fd; if(s<0)s=0; print s}')
      ffmpeg -nostdin -v error -y -i "$f" -an \
        -vf "scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080,setpts=PTS*$SLOW,fps=30,format=yuv420p,fade=t=in:d=$FADE,fade=t=out:st=$st:d=$FADE" \
        -c:v libx264 -preset medium -crf 20 "$TMP/c$i.mp4" ;;
  esac
  echo "file '$TMP/c$i.mp4'" >> "$TMP/list.txt"
done

# 2) segmentul de baza
ffmpeg -v error -y -f concat -safe 0 -i "$TMP/list.txt" -c copy "$TMP/segment.mp4"
SEG=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$TMP/segment.mp4")
echo "Segment de baza: ${SEG}s din ${#FILES[@]} clipuri"

# 3) repeta segmentul pana la DURATION (fara re-encodare)
ffmpeg -v error -y -stream_loop -1 -i "$TMP/segment.mp4" -t "$DURATION" -c copy "$TMP/video.mp4"

# 4) audio: daca e folder, concateneaza melodiile; apoi bucla
if [ -d "$AUDIO" ]; then
  : > "$TMP/alist.txt"; j=0
  while IFS= read -r a; do j=$((j+1)); ffmpeg -nostdin -v error -y -i "$a" -ar 44100 -ac 2 "$TMP/a$j.wav"; echo "file '$TMP/a$j.wav'" >> "$TMP/alist.txt"; done < <(find "$AUDIO" -maxdepth 1 -type f \( -iname '*.mp3' -o -iname '*.wav' -o -iname '*.m4a' \) | sort)
  [ $j -gt 0 ] || { echo "Nu am gasit melodii in $AUDIO"; exit 1; }
  ffmpeg -v error -y -f concat -safe 0 -i "$TMP/alist.txt" -c copy "$TMP/all.wav"; AUDIO="$TMP/all.wav"
fi
# audio in bucla, cu fade-out la final, apoi lipire
ffmpeg -v error -y -stream_loop -1 -i "$AUDIO" -t "$DURATION" \
  -af "afade=t=in:d=3,afade=t=out:st=$(awk -v d="$DURATION" 'BEGIN{print d-8}'):d=8" \
  -c:a aac -b:a 192k "$TMP/audio.m4a"
ffmpeg -v error -y -i "$TMP/video.mp4" -i "$TMP/audio.m4a" -c copy -shortest -movflags +faststart "$OUT"
echo "Gata: $OUT ($(ffprobe -v error -show_entries format=duration -of csv=p=0 "$OUT")s)"
