# Videoul de duminică 1 noiembrie: Ocean Waves & Calm Piano for Sleep | 3 Hours

Titlul este cel planificat în calendar. Sâmbătă 31 oct, la 19:35, analiza automată poate propune altă temă; dacă o schimbăm, refac fișierul.

## 1) Titlu și descriere (gata de copiat)

**Titlu EN:** Ocean Waves & Calm Piano for Sleep | 3 Hours
**Titlu RO:** Valurile oceanului și pian calm pentru somn | 3 ore

**Descriere EN**

🌊 Long, slow waves roll onto a quiet shore, matched by unhurried piano notes. 3 hours of ocean waves and calm piano to help you slow down, breathe and unwind.

✨ Perfect for: sleep, study, work, meditation, yoga, reading or a quiet evening.

⏱️ Chapters (the sequence repeats)
0:00 Soft start
(adaugă minutajul real după montaj)

🎧 Tip: headphones or a quiet room, volume low. Let it play and let go.

🔔 Join our calm community, new music every week: https://www.youtube.com/@SoundsAndDreamscapes?sub_confirmation=1
💬 Tell us in the comments where you are listening from and what time it is there.
👍 If this helped you relax, like and share it with someone who needs a moment of calm.

🎵 Music and visuals: created with AI.
© Sounds and Dreamscapes

#oceanwaves #pianomusic #sleepmusic #relaxingmusic #calmmusic

**Descriere RO**

🌊 Valuri lungi și lente ajung pe un țărm liniștit, însoțite de note de pian fără grabă. 3 ore de valuri de ocean și pian calm ca să încetinești, să respiri și să te destinzi.

✨ Potrivit pentru: somn, studiu, muncă, meditație, yoga, citit sau o seară liniștită.

🎧 Sfat: căști sau o cameră liniștită, volum mic. Lasă muzica să meargă.

🔔 Alătură-te comunității noastre liniștite, muzică nouă în fiecare săptămână: https://www.youtube.com/@SoundsAndDreamscapes?sub_confirmation=1
💬 Scrie-ne în comentarii de unde asculți și cât e ceasul acolo.
👍 Dacă te-a ajutat să te relaxezi, dă like și trimite-l cuiva care are nevoie de o clipă de liniște.

🎵 Muzică și imagini: create cu AI.
© Sounds and Dreamscapes

**La încărcare:** bifează „Altered content”. Miniatură: cadru luminos cu valuri și textul „3 HOURS”.

## 2) Ce îi ceri lui Gemini

### Promptul de pornire (lipește-l o singură dată pentru clipuri)

```
You will create 8-second 16:9 horizontal photorealistic nature video clips for a relaxing music channel. Rules for every clip: no people, no text, no logos, no watermarks, slow gentle camera movement or a still camera, soft natural light, warm vivid colors, calm and peaceful mood, no snow, no dark scenes. I will give you a scene; make exactly one clip, then wait for my next scene.
```

### Scenele (una câte una, scrii doar linia)

1. Scene: Long gentle ocean waves rolling onto a golden sandy beach at sunrise, slow camera drift
2. Scene: Calm turquoise sea with soft foam washing over white sand, still camera
3. Scene: Waves breaking softly on smooth rocks, warm morning light, slow motion
4. Scene: Wide ocean horizon at golden hour with a few soft clouds, slow push-in
5. Scene: Shallow clear water rippling over sand and shells, close view, soft light
6. Scene: Quiet beach at dawn with low mist over the water, slow pan
7. Scene: Gentle waves reaching dune grass on an empty coast, warm light
8. Scene: Pink and gold sky reflecting on wet sand as a wave retreats
9. Scene: Calm bay with small waves and distant green cliffs, still camera
10. Scene: Sunlight sparkling on slow ocean waves, aerial drift above the water
11. Scene: Rocky shoreline with soft surf and tide pools, sunrise glow
12. Scene: Turquoise lagoon with tiny waves and palm shadows, slow drift
13. Scene: Soft waves at the water's edge, slow motion foam patterns
14. Scene: Empty pier or wooden walkway over calm water at sunrise, still camera
15. Scene: Sea at blue hour dawn, soft light, gentle waves, not dark
16. Scene: Wide sandy beach with long smooth waves, early morning, slow aerial pull-back

Salvează-le ca `01-valuri.mp4` … `16-valuri.mp4`.

### Muzica (în Gemini, funcția de muzică)

```
2-3 minute instrumental calm piano with soft ambient pads, 60-70 BPM, warm and dreamy, theme: TEMA. No vocals, no drums, calm, seamless and suitable for looping.
```

Schimbi TEMA, pe rând: calm ocean waves at sunrise / gentle waves on a quiet beach / turquoise sea and soft foam / golden hour by the water / slow tide and soft light / peaceful bay at dawn

Salvează ca `01.mp3` … `06.mp3`.

## 3) Cum îmi trimiți fișierele

Din containerul meu nu pot descărca de pe Dropbox/Google Drive. Merge prin GitHub: repo `igorturcanu/cistig`, branch `ccr-dcef6c4d-g3430i`, folderul `youtube/video-3h/media/`, **Add file → Upload files** (max. 25 MB/fișier). Pune clipurile în `media/clipuri/` și melodiile în `media/muzica/`. După ce îmi scrii „am urcat", le iau de acolo.

Ce fac eu: un test de 2 minute, ca să vezi cum arată. Videoul de 3 ore (câțiva GB) nu ți-l pot trimite înapoi de aici; îl generezi tu cu:

`SLOW=2 ./build_3h.sh clipuri/ muzica/ ocean-waves-3h.mp4`

16 clipuri de ~8 s înseamnă ~2 minute unice (~4 cu `SLOW=2`). La 3 ore se repetă de zeci de ori; cu mai multe clipuri arată mai bine. Dacă Gemini îți dă limită zilnică, generează câteva azi și câteva mâine.
