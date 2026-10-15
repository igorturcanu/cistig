#!/usr/bin/env bash
# Construiește un videoclip lung (implicit 3 ore) cu ploaie + muzică ambientală
# peste o imagine statică, gata de urcat pe YouTube.
#
# Utilizare:
#   ./build_video.sh imagine.jpg ploaie.mp3 muzica.mp3 [iesire.mp4] [secunde]
#
#   imagine.jpg  - imaginea de fundal (recomandat 1920x1080)
#   ploaie.mp3   - sunet de ploaie (se repetă în buclă)
#   muzica.mp3   - muzică ambientală (se repetă în buclă)
#   secunde      - durata totală; implicit 10800 (3 ore)
#
# Folosește doar audio și imagini pe care ai dreptul să le folosești
# (create de tine, generate cu AI, licențiate sau libere de drepturi).
set -euo pipefail

if [ "$#" -lt 3 ]; then
  sed -n '2,13p' "$0"
  exit 1
fi

IMG="$1"; RAIN="$2"; MUSIC="$3"
OUT="${4:-ploaie_3_ore.mp4}"
DUR="${5:-10800}"
FADE=5

# Video: 1 fps e suficient pentru imagine statică (fișier mic, encodare rapidă).
# Audio: ploaia (volum 100%) + muzica (volum 45%), ambele în buclă, fade in/out.
ffmpeg -y -loglevel error -stats \
  -loop 1 -framerate 1 -i "$IMG" \
  -stream_loop -1 -i "$RAIN" \
  -stream_loop -1 -i "$MUSIC" \
  -filter_complex "\
[1:a]volume=1.0[r];\
[2:a]volume=0.45[m];\
[r][m]amix=inputs=2:duration=longest:normalize=0,\
afade=t=in:d=${FADE},afade=t=out:st=$((DUR-FADE)):d=${FADE}[a];\
[0:v]scale=1920:1080:force_original_aspect_ratio=decrease,\
pad=1920:1080:(ow-iw)/2:(oh-ih)/2,format=yuv420p[v]" \
  -map "[v]" -map "[a]" \
  -c:v libx264 -preset veryfast -tune stillimage -crf 28 -r 1 \
  -c:a aac -b:a 192k -ar 44100 \
  -t "$DUR" -movflags +faststart "$OUT"

echo "Gata: $OUT"
