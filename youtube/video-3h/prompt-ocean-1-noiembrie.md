# Prompturi Gemini: Ocean Waves & Calm Piano for Sleep | 3 Hours

Tema: **ocean waves** · 16 clipuri x 8 s (~2 min 8 s unice) · 6 melodii x ~2 min 30 s (piano)

Clipurile si muzica generate cu Gemini sunt create cu AI: scrie asta in descriere si bifeaza „Altered content”.

## 1) CLIPURI: lipesti tot blocul de mai jos O SINGURA DATA

Apoi, dupa fiecare clip, scrii doar `next`. Nu mai repeti nimic.

```
You are generating 16 separate 8-second 16:9 horizontal photorealistic nature video clips for a relaxing music channel. Theme: ocean waves.
Rules for EVERY clip: no people, no text, no logos, no watermarks, soft natural light, warm vivid colors, calm peaceful mood, no snow, no dark scenes, slow gentle camera movement or a still camera, no fast motion, no cuts inside a clip.
Make exactly ONE clip at a time, in the order below. After each clip, wait until I write "next", then make the next one. Do not repeat a scene. Clip numbers must match the list.

01. long gentle ocean waves rolling onto a golden sandy beach at sunrise, slow camera drift
02. calm turquoise sea with soft foam washing over white sand at sunset, very slow slide to the left
03. waves breaking softly on smooth rocks at dawn with a pink sky, slow aerial pull-back
04. wide ocean horizon with a few soft clouds in soft morning light, slow pan to the right
05. shallow clear water rippling over sand and shells under a bright calm sky, slow push-in
06. quiet beach with low mist over the water in gentle diffused light, still camera
07. gentle waves reaching dune grass on an empty coast at golden hour, slow camera drift
08. wet sand reflecting the sky as a wave retreats in warm afternoon light, very slow slide to the left
09. calm bay with small waves and distant green cliffs at sunrise, slow aerial pull-back
10. sunlight sparkling on slow ocean waves at sunset, slow pan to the right
11. rocky shoreline with soft surf and tide pools at dawn with a pink sky, slow push-in
12. turquoise lagoon with tiny waves and palm shadows in soft morning light, still camera
13. long gentle ocean waves rolling onto a golden sandy beach in warm afternoon light, still camera
14. calm turquoise sea with soft foam washing over white sand at sunrise, slow camera drift
15. waves breaking softly on smooth rocks at sunset, very slow slide to the left
16. wide ocean horizon with a few soft clouds at dawn with a pink sky, slow aerial pull-back
```

Salveaza clipurile ca `01.mp4`, `02.mp4` … `16.mp4` in folderul `clipuri/`.

## 2) MUZICA: lipesti blocul O SINGURA DATA, apoi `next`

```
You are generating 6 separate instrumental tracks, each about 2 minutes 30 seconds long, for a relaxing ocean waves video. Style for all: calm piano with soft ambient pads, 60-70 BPM, no vocals, no drums, calm, seamless and suitable for looping, every track clearly different in melody from the others.
Make exactly ONE track at a time, in the order below. After each track, wait until I write "next".

01. Mood: warm and dreamy, inspired by long gentle ocean waves rolling onto a golden sandy beach at sunrise
02. Mood: soft and spacious, inspired by calm turquoise sea with soft foam washing over white sand at sunset
03. Mood: gentle and flowing, inspired by waves breaking softly on smooth rocks at dawn with a pink sky
04. Mood: quiet and reflective, inspired by wide ocean horizon with a few soft clouds in soft morning light
05. Mood: bright and peaceful, inspired by shallow clear water rippling over sand and shells under a bright calm sky
06. Mood: slow and deeply calm, inspired by quiet beach with low mist over the water in gentle diffused light
```

Salveaza ca `01.mp3` … `06.mp3` in folderul `muzica/`.

## 3) Asamblare (pe calculatorul tau, cu ffmpeg)

```
SLOW=2 ./build_3h.sh clipuri/ muzica/ video-3h.mp4
```

Cu 16 clipuri de 8 s ai ~2 min 8 s unice; `SLOW=2` le dubleaza. Cu mai multe clipuri video-ul se repeta mai putin vizibil.
