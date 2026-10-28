# Prompturi pentru Gemini: teme din cele mai noi videouri populare
## Ce am luat din videourile noi (oct 2026)

Din ultimele videouri ale canalului, cele mai vizionate teme sunt: cascadă și lac (Shorturi de 226, 153, 144 de vizionări), dimineață în munți (131 și 154; videoul de 10 minute cu peisaje montane: 852) și pădure cu pian liniștit (251, 226). Toate au sub 1.000 de vizionări, deci sunt semnale slabe; scenele reale (handpan, Benidorm, Rotterdam) rămân mult peste (vezi `../analiza-canal.md`).

Clipurile generate cu Gemini sunt create cu AI. În descriere scrie asta și bifează „Altered content”.

## 1) Promptul de pornire (îl lipești o singură dată în Gemini)

```
You will create 8-second 16:9 horizontal photorealistic nature video clips for a relaxing music channel. Rules for every clip: no people, no text, no logos, no watermarks, slow gentle camera movement or a still camera, soft natural light, warm vivid colors, calm and peaceful mood, no snow, no dark scenes. I will give you a scene; make exactly one clip, then wait for my next scene.
```

## 2) Scenele (câte una, scrii doar linia; Gemini face câte un clip)

### A. Cascadă și lac (cele mai repetate în Shorturile recente: 226, 153, 144, 88, 71 de vizionări)

1. Scene: Forest waterfall with moss and ferns, soft morning light
2. Scene: Waterfall flowing into a calm turquoise lake, slow camera drift
3. Scene: Mountain stream running over smooth stones into a quiet lake
4. Scene: Small waterfall in a bright green jungle, light mist
5. Scene: Calm lake at golden hour with gentle ripples
6. Scene: Waterfall and river in morning sun, slow motion water
7. Scene: Lake shore with reeds and soft dawn light
8. Scene: Hidden waterfall pool with clear water and sunbeams

### B. Dimineață în munți (131, 154 de vizionări; videoul de 10 min cu peisaje montane a avut 852)

9. Scene: Sunrise over a mountain valley with soft mist, slow aerial drift
10. Scene: Mountain peaks glowing in first light above low clouds
11. Scene: Alpine meadow at dawn with dew on the grass
12. Scene: Mountain lake reflecting a pink and gold sunrise
13. Scene: Green hills layered in morning fog, gentle camera push-in
14. Scene: Sunbeams breaking through clouds over a mountain ridge
15. Scene: Quiet mountain path at sunrise with wildflowers
16. Scene: Wide mountain landscape in warm morning light, calm sky

### C. Pădure, pian, natură liniștită (251, 226 de vizionări)

17. Scene: Sunlit forest path with floating particles, slow walk
18. Scene: Forest river at dawn with soft reflections
19. Scene: Autumn forest with golden leaves and sun rays
20. Scene: Moss-covered stones and ferns by a creek
21. Scene: Calm lake at dawn with mist rising
22. Scene: Peaceful meadow with wildflowers swaying slowly
23. Scene: Tall trees with sunbeams, quiet forest clearing
24. Scene: Gentle rain on forest leaves, soft light

### D. Mare și apus (testare)

25. Scene: Calm ocean at sunrise, slow waves on a golden beach
26. Scene: Tropical beach at sunset with soft waves
27. Scene: Shallow turquoise water over white sand
28. Scene: Rocky coast with gentle surf and pink sky

Total: 28 de scene. Salvează fiecare clip ca `NN-tema.mp4` (ex. `01-cascada.mp4`, `09-munti.mp4`), în ordinea numerelor.

## 3) Muzica

Promptul (de 6–8 ori, schimbi TEMA din lista de mai jos):

```
2-3 minute instrumental relaxing piano and soft ambient melody, 60-70 BPM, warm and dreamy, theme: TEMA. No vocals, no drums, calm, seamless and suitable for looping.
```

Teme: forest waterfall / mountain sunrise / calm lake at dawn / forest river / morning meadow / ocean at sunrise.
Dacă vrei handpan: înlocuiește „piano and soft ambient melody” cu „handpan melody”.
Salvează ca `01.mp3`, `02.mp3` …

## 4) Cum îmi trimiți fișierele

Aici nu pot descărca de pe Dropbox/Google Drive (acces blocat din containerul meu). Metodele care merg:
1. **GitHub (recomandat dacă sunt puține):** deschide repo-ul `igorturcanu/cistig`, branch-ul `ccr-dcef6c4d-g3430i`, intră în `youtube/video-3h/media/`, **Add file → Upload files** și trage clipurile și melodiile. Limita în browser: 25 MB/fișier, 100 de fișiere o dată. Atenție: fișierele ajung și în PR-ul #3. După ce le folosesc, le scot.
2. **Pe calculatorul tău (recomandat dacă ai peste ~500 MB):** pui clipurile în `clipuri/`, melodiile în `muzica/` și rulezi `SLOW=2 ./build_3h.sh clipuri/ muzica/ video-3h.mp4`.

În ambele cazuri **videoul final de 3 ore (câțiva GB) nu pot să ți-l trimit înapoi de aici**. Dacă îmi urci clipurile, pot face un test de 2 minute pe care să-l poți vedea, iar videoul complet îl rulezi tu cu scriptul.
