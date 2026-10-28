# Prompturi pentru Gemini: clipuri și muzică
Atenție: clipurile generate cu Gemini (Veo) și muzica generată sunt **create cu AI**. Videoul nu mai e cu „imagini reale”. În descriere scrie că imaginile și muzica sunt create cu AI și bifează „Altered content” la încărcare.
Verifică în contul tău Gemini ce limită zilnică de clipuri ai și cât durează un clip (de obicei ~8 secunde). 25 de clipuri × 8 s = ~3,5 minute unice; la 3 ore se repetă de ~50 de ori, de aceea scriptul poate încetini clipurile cu `SLOW=2`. Cu cât ai mai multe clipuri, cu atât mai bine.
## Promptul de pornire (îl lipești o singură dată)

```
You will create 8-second 16:9 horizontal photorealistic nature video clips for a relaxing music channel. Rules for every clip: no people, no text, no logos, no watermarks, slow gentle camera movement or a still camera, soft natural light, warm vivid colors, calm and peaceful mood, no snow, no dark scenes. I will give you a scene; make one clip, then wait for my next scene.
```
## Scenele (una câte una, scrii doar linia)

1. Scene: Jungle waterfall pouring into a green pool, light mist
2. Scene: Ocean waves rolling slowly onto a golden beach at sunrise
3. Scene: Clear stream over smooth stones in an autumn forest
4. Scene: Turquoise mountain lake reflecting snowless green peaks
5. Scene: Gentle rain falling on large green leaves
6. Scene: Tropical beach at sunset with palm silhouettes and soft waves
7. Scene: Wildflower meadow swaying in a light breeze under a colorful sky
8. Scene: Old wooden bridge over a calm river in morning light
9. Scene: Sand dunes at golden hour with gentle wind ripples
10. Scene: Golden autumn orchard with sunbeams through the leaves
11. Scene: Rocky coast with soft waves and a pink evening sky
12. Scene: Lake covered in water lilies, dragonflies, still water
13. Scene: Lavender field in warm evening light
14. Scene: Green mountain waterfalls in slow motion
15. Scene: Misty valley at dawn with drifting fog
16. Scene: Japanese garden with red maple leaves and a small pond
17. Scene: Crystal clear shallow water over a rocky shore
18. Scene: Bamboo forest with sunlight moving through the stalks
19. Scene: Palm trees on a beach at golden hour
20. Scene: Still lake at sunrise with wooden rowboats
21. Scene: Pine forest with sunbeams and floating dust
22. Scene: Calm river winding through green hills
23. Scene: Turquoise tropical island seen from above, slow aerial drift
24. Scene: Golden wheat field at sunset moving in the wind
25. Scene: Quiet forest path with falling autumn leaves

Salvează clipurile ca `1.mp4` … `25.mp4` într-un folder `clipuri/`.

## Muzica (în Gemini, funcția de muzică)

Promptul (repetă-l de 5–8 ori, schimbând „theme"):

```
2-3 minute instrumental relaxing handpan melody, soft ambient pads, 60-70 BPM, warm and dreamy, theme: TEMA. No vocals, no drums, calm, seamless and suitable for looping.
```

Teme: forest stream / ocean at sunrise / evening meadow / quiet lake / rain on leaves / sunset beach / mountain mist / golden hour.

Pune melodiile într-un folder `muzica/` (MP3 sau WAV). Scriptul le leagă una după alta și le repetă în buclă până la 3 ore.

## Rularea

`SLOW=2 ./build_3h.sh clipuri/ muzica/ video-3h.mp4`

`SLOW=1` lasă clipurile la viteza lor; `SLOW=2` le face de 2 ori mai lungi și mai liniștite.

## Cum mi le trimiți

Pune folderele `clipuri/` și `muzica/` într-un folder Dropbox și spune-mi calea. Nu pot garanta că pot descărca fișierele mari de acolo; dacă nu merge, rulezi scriptul tu, pe calculatorul tău.
