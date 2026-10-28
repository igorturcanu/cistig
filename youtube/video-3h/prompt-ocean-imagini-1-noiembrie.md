# Prompturi Gemini: Ocean Waves & Calm Piano for Sleep | 3 Hours

Tema: **ocean waves** · 30 imagini x 12 s (~6 min 0 s unice) · 6 melodii x ~2 min 30 s (piano)

Clipurile si muzica generate cu Gemini sunt create cu AI: scrie asta in descriere si bifeaza „Altered content”.

## 1) IMAGINI: lipesti tot blocul de mai jos O SINGURA DATA

Apoi, dupa fiecare clip, scrii doar `next`. Nu mai repeti nimic.

```
You are generating 30 separate 16:9 horizontal photorealistic nature IMAGES (not video, not text) for a relaxing music channel. Theme: ocean waves.
Rules for EVERY image: no people, no text, no logos, no watermarks, soft natural light, warm vivid colors, calm peaceful mood, no snow, no dark scenes, sharp high detail, natural composition.
Make exactly ONE image at a time, in the order below. After each image, wait until I write "next", then make the next one. Do not repeat a scene. Image numbers must match the list.

01. long gentle ocean waves rolling onto a golden sandy beach at sunrise
02. calm turquoise sea with soft foam washing over white sand at sunset
03. waves breaking softly on smooth rocks at dawn with a pink sky
04. wide ocean horizon with a few soft clouds in soft morning light
05. shallow clear water rippling over sand and shells under a bright calm sky
06. quiet beach with low mist over the water in gentle diffused light
07. gentle waves reaching dune grass on an empty coast at golden hour
08. wet sand reflecting the sky as a wave retreats in warm afternoon light
09. calm bay with small waves and distant green cliffs at sunrise
10. sunlight sparkling on slow ocean waves at sunset
11. rocky shoreline with soft surf and tide pools at dawn with a pink sky
12. turquoise lagoon with tiny waves and palm shadows in soft morning light
13. long gentle ocean waves rolling onto a golden sandy beach in warm afternoon light
14. calm turquoise sea with soft foam washing over white sand at sunrise
15. waves breaking softly on smooth rocks at sunset
16. wide ocean horizon with a few soft clouds at dawn with a pink sky
17. shallow clear water rippling over sand and shells in soft morning light
18. quiet beach with low mist over the water under a bright calm sky
19. gentle waves reaching dune grass on an empty coast in gentle diffused light
20. wet sand reflecting the sky as a wave retreats at golden hour
21. calm bay with small waves and distant green cliffs in warm afternoon light
22. sunlight sparkling on slow ocean waves at sunrise
23. rocky shoreline with soft surf and tide pools at sunset
24. turquoise lagoon with tiny waves and palm shadows at dawn with a pink sky
25. long gentle ocean waves rolling onto a golden sandy beach at golden hour
26. calm turquoise sea with soft foam washing over white sand in warm afternoon light
27. waves breaking softly on smooth rocks at sunrise
28. wide ocean horizon with a few soft clouds at sunset
29. shallow clear water rippling over sand and shells at dawn with a pink sky
30. quiet beach with low mist over the water in soft morning light
```

Salveaza imaginile ca `01.jpg`, `02.jpg` … `30.jpg` in folderul `clipuri/`.

Daca Gemini te intreaba sau raspunde doar cu text, scrie: `Generate the image now.`

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
IMGDUR=12 ./build_3h.sh clipuri/ muzica/ video-3h.mp4
```

Cu 30 imagini x 12 s ai ~6 min 0 s unice (fiecare imagine primeste un zoom lent). Mai multe imagini = repetare mai putin vizibila.
