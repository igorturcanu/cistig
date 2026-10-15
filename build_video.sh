#!/usr/bin/env bash
# Construiește un videoclip lung (implicit 3 ore) cu ploaie + muzică ambientală
# peste mai multe imagini care se schimbă lent, cu tranziție fade.
#
# Utilizare:
#   ./build_video.sh DIRECTOR_IMAGINI ploaie.mp3 muzica.mp3 [iesire.mp4] [secunde] [sec_per_imagine]
#
#   DIRECTOR_IMAGINI - folder cu imagini .jpg/.jpeg/.png (se iau în ordine alfabetică)
#                      (poate fi și o singură imagine)
#   ploaie.mp3       - sunet de ploaie (se repetă în buclă); pune - ca să nu ai ploaie
#   muzica.mp3       - muzică ambientală (se repetă în buclă); poate fi și un folder
#                      cu mai multe piese (.mp3/.wav/.m4a), puse una după alta
#   secunde          - durata totală; implicit 10800 (3 ore)
#   sec_per_imagine  - cât timp rămâne fiecare imagine; implicit 300 (5 minute)
#
# Folosește doar audio și imagini pe care ai dreptul să le folosești
# (create de tine, generate cu AI, licențiate sau libere de drepturi).
set -euo pipefail

if [ "$#" -lt 3 ]; then
  sed -n '2,18p' "$0"
  exit 1
fi

SRC="$1"; RAIN="$2"; MUSIC="$3"
OUT="${4:-ploaie_3_ore.mp4}"
DUR="${5:-10800}"
SEC="${6:-300}"
FADE=5      # fade-in/out audio (secunde)
XF=3        # durata tranziției dintre imagini (secunde)

if [ -d "$SRC" ]; then
  mapfile -t IMGS < <(find "$SRC" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) | sort)
else
  IMGS=("$SRC")
fi
N=${#IMGS[@]}
[ "$N" -ge 1 ] || { echo "Nu am găsit imagini în $SRC" >&2; exit 1; }

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
NORM="scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2,setsar=1,fps=1,format=yuv420p"

# Pasul 1: un clip de prezentare (slideshow) cu toate imaginile, care se va repeta.
LOOPCLIP="$TMP/slides.mp4"
if [ "$N" -eq 1 ]; then
  ffmpeg -y -loglevel error -loop 1 -framerate 1 -t "$SEC" -i "${IMGS[0]}" \
    -vf "$NORM" -c:v libx264 -preset veryfast -tune stillimage -crf 28 "$LOOPCLIP"
else
  INPUTS=(); FILTER=""
  for i in "${!IMGS[@]}"; do
    INPUTS+=(-loop 1 -framerate 1 -t $((SEC + XF)) -i "${IMGS[$i]}")
    FILTER+="[$i:v]${NORM}[v$i];"
  done
  PREV="v0"
  for ((i = 1; i < N; i++)); do
    FILTER+="[${PREV}][v$i]xfade=transition=fade:duration=${XF}:offset=$((i * SEC))[x$i];"
    PREV="x$i"
  done
  ffmpeg -y -loglevel error "${INPUTS[@]}" \
    -filter_complex "${FILTER%;}" -map "[${PREV}]" \
    -c:v libx264 -preset veryfast -crf 28 -r 1 -t $((N * SEC)) "$LOOPCLIP"
fi

# Muzică dintr-un folder: lipește piesele într-un singur fișier.
if [ -d "$MUSIC" ]; then
  : > "$TMP/list.txt"
  while IFS= read -r f; do printf "file '%s'\n" "$(realpath "$f")" >> "$TMP/list.txt"; done \
    < <(find "$MUSIC" -maxdepth 1 -type f \( -iname '*.mp3' -o -iname '*.wav' -o -iname '*.m4a' \) | sort)
  [ -s "$TMP/list.txt" ] || { echo "Nu am găsit piese în $MUSIC" >&2; exit 1; }
  ffmpeg -y -loglevel error -f concat -safe 0 -i "$TMP/list.txt" -c:a pcm_s16le -ar 44100 "$TMP/music.wav"
  MUSIC="$TMP/music.wav"
fi

# Pasul 2: repetă slideshow-ul pe toată durata și adaugă audio.
# Cu ploaie: ploaie 100% + muzică 45%. Fără ploaie ("-"): doar muzica.
if [ "$RAIN" = "-" ]; then
  AIN=(-stream_loop -1 -i "$MUSIC")
  AFILTER="[1:a]volume=0.9,"
else
  AIN=(-stream_loop -1 -i "$RAIN" -stream_loop -1 -i "$MUSIC")
  AFILTER="[1:a]volume=1.0[r];[2:a]volume=0.45[m];[r][m]amix=inputs=2:duration=longest:normalize=0,"
fi
ffmpeg -y -loglevel error -stats \
  -stream_loop -1 -t "$DUR" -i "$LOOPCLIP" \
  "${AIN[@]}" \
  -filter_complex "${AFILTER}afade=t=in:d=${FADE},afade=t=out:st=$((DUR - FADE)):d=${FADE}[a]" \
  -map 0:v -map "[a]" \
  -c:v copy -c:a aac -b:a 192k -ar 44100 \
  -t "$DUR" -movflags +faststart "$OUT"

echo "Gata: $OUT ($N imagini, ${DUR}s)"
