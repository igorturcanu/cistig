# Video de 3 ore: handpan + imagini reale (Pexels)

## Ce ai nevoie

1. **Muzica:** una sau mai multe înregistrări proprii cu handpan, 10–20 de minute în total, fără voci străine și fără muzică a altora. Format MP3/WAV.
2. **Clipuri video:** 15–25 de clipuri de natură de pe pexels.com (licență Pexels: gratuite, fără atribuire obligatorie). Descarcă-le în rezoluție HD sau 4K.
3. **Un calculator** cu `ffmpeg` instalat (Windows: `winget install ffmpeg`; Mac: `brew install ffmpeg`).

## Ce să cauți pe Pexels (câte 1–2 clipuri la fiecare)

waterfall forest, ocean waves slow motion, sunrise mountains, lake reflection, river stream rocks, rain on leaves, bamboo forest, beach sunset, meadow flowers wind, misty forest morning, tropical palm beach, autumn forest path, lavender field, clouds time lapse, koi pond.

Reguli: doar clipuri fără oameni care se văd clar, fără text sau logo-uri, fără sunet de fundal (scriptul îl scoate oricum), cu mișcare lentă. Fiecare 20–40 de secunde. Păstrează o listă cu linkul fiecărui clip.

## Cum îl faci

1. Pune clipurile într-un folder `clipuri/` și melodia ca `handpan.mp3`.
2. Rulează: `./build_3h.sh clipuri/ handpan.mp3 handpan-3h.mp4`
3. Rezultat: 3 ore exact (10800 s), 1080p, 30 fps. Poți scurta la test: `DURATION=120 ./build_3h.sh clipuri/ handpan.mp3 test.mp4`.
4. Scriptul a fost testat cu clipuri sintetice (durată corectă, 1920x1080, h264 + aac). Nu l-am rulat pe clipuri Pexels reale sau pe muzica ta.

Atenție: segmentul de bază (toate clipurile puse una după alta) se repetă în buclă. Cu 15–25 de clipuri de ~30 s ai ~10–12 minute unice; cu mai puțin, YouTube și spectatorii pot vedea videoul ca repetitiv.

## Titlu și descriere (pentru copiat)

**Titlu EN:** Handpan & Nature | 3 Hours of Calm Music
**Titlu RO:** Handpan și natură | 3 ore de muzică liniștită

**Descriere EN**
🌿 Gentle handpan music over real nature footage: water, forests, sunsets and quiet skies. 3 hours to slow down, breathe and unwind.

✨ Perfect for: sleep, study, work, meditation, yoga, reading or a quiet evening.

⏱️ Chapters (the sequence repeats every ~10 minutes)
0:00 Start
(adaugă minutajul real după montaj)

🎧 Tip: headphones or a quiet room, volume low.

🔔 Join our calm community, new music every week: https://www.youtube.com/@SoundsAndDreamscapes?sub_confirmation=1
💬 Tell us where you are listening from.
👍 If it helped you relax, like and share it with someone who needs a moment of calm.

🎵 Music: original handpan recordings by Sounds and Dreamscapes.
🎬 Footage: free-to-use stock footage from Pexels (links in the pinned comment).
© Sounds and Dreamscapes

**Descriere RO**
🌿 Muzică blândă de handpan peste imagini reale din natură: ape, păduri, apusuri și cer liniștit. 3 ore ca să încetinești, să respiri și să te destinzi.

✨ Potrivit pentru: somn, studiu, muncă, meditație, yoga, citit sau o seară liniștită.

🔔 Alătură-te comunității, muzică nouă în fiecare săptămână: https://www.youtube.com/@SoundsAndDreamscapes?sub_confirmation=1
👍 Dacă te-a ajutat să te relaxezi, dă like și trimite-l mai departe.

🎵 Muzică: înregistrări proprii cu handpan.
🎬 Imagini: filmări gratuite de stoc de la Pexels (linkurile în comentariul fixat).

**Hashtag-uri:** #handpan #relaxingmusic #naturesounds #sleepmusic #calmmusic

## Înainte de încărcare

- Nu bifa „Altered content” doar dacă muzica și imaginile sunt reale; dacă ai folosit AI pentru ceva, bifează.
- Pune în comentariul fixat linkurile clipurilor Pexels.
- Miniatura: un cadru real, luminos, cu textul „3 HOURS” mare.
