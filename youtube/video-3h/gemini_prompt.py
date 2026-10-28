#!/usr/bin/env python3
"""Genereaza prompturile pentru Gemini pentru un video lung (clipuri + melodii).

Exemple:
  python3 gemini_prompt.py --tema ocean --clipuri 16 --melodii 6
  python3 gemini_prompt.py --tema "waterfall" --clipuri 24 --durata 10 --melodii 8 --instrument handpan
  python3 gemini_prompt.py --tema "autumn park" --titlu "Autumn Park & Piano | 3 Hours"   # tema libera

Scrie un fisier .md cu: (1) un prompt de lipit O SINGURA DATA pentru clipuri, cu toata lista
de scene si regulile, (2) un prompt pentru muzica cu toate variantele, (3) numele fisierelor,
(4) comanda de asamblare. Nu are dependente (doar Python 3).
"""
import argparse, itertools, sys

THEMES = {
  "ocean":    ("ocean waves", ["long gentle ocean waves rolling onto a golden sandy beach","calm turquoise sea with soft foam washing over white sand","waves breaking softly on smooth rocks","wide ocean horizon with a few soft clouds","shallow clear water rippling over sand and shells","quiet beach with low mist over the water","gentle waves reaching dune grass on an empty coast","wet sand reflecting the sky as a wave retreats","calm bay with small waves and distant green cliffs","sunlight sparkling on slow ocean waves","rocky shoreline with soft surf and tide pools","turquoise lagoon with tiny waves and palm shadows"]),
  "waterfall":("forest waterfall", ["waterfall with moss and ferns","waterfall flowing into a calm turquoise pool","small waterfall in a bright green jungle with light mist","hidden waterfall pool with clear water and sunbeams","green mountain waterfalls over dark wet rock","stream running over smooth stones below a waterfall","waterfall and river among tall trees","gentle cascades over mossy steps"]),
  "lake":     ("calm lake", ["calm lake with gentle ripples","lake shore with tall reeds","mountain lake reflecting the sky","lake with wooden rowboats near the shore","still lake with water lilies","lake and green hills with soft mist","clear shallow water at the edge of a lake","wide lake with distant mountains"]),
  "mountain": ("mountain valley", ["mountain valley with soft mist","peaks glowing above low clouds","alpine meadow with dew on the grass","mountain lake reflecting a colorful sky","green hills layered in fog","sunbeams breaking through clouds over a ridge","quiet mountain path with wildflowers","wide mountain landscape under a calm sky"]),
  "forest":   ("quiet forest", ["sunlit forest path with floating particles","forest river with soft reflections","forest with golden autumn leaves and sun rays","moss-covered stones and ferns by a creek","tall trees with sunbeams in a clearing","bamboo forest with light moving through the stalks","pine forest with soft sunbeams","gentle rain on forest leaves"]),
  "meadow":   ("flower meadow", ["wildflower meadow swaying slowly","lavender field in warm light","poppy meadow under a clear sky","sunflower field in a light breeze","golden wheat field moving in the wind","meadow with butterflies in sunshine","hillside covered in wildflowers","green meadow with a small stream"]),
  "beach":    ("tropical beach", ["tropical beach with palm silhouettes and soft waves","shallow turquoise water over white sand","palm grove by a calm sea","rocky coast with gentle surf","empty tropical bay with clear water","beach hut on a sunny shore","coconut palms moving in a light breeze","turquoise island seen from above"]),
}
LIGHT  = ["at sunrise","in soft morning light","at golden hour","at sunset","under a bright calm sky","in warm afternoon light","at dawn with a pink sky","in gentle diffused light"]
CAMERA = ["slow camera drift","still camera","slow push-in","slow pan to the right","slow aerial pull-back","very slow slide to the left"]
MUSIC_MOODS = ["warm and dreamy","soft and spacious","gentle and flowing","quiet and reflective","bright and peaceful","slow and deeply calm","airy and light","tender and calm"]

def scenes(theme, n):
    key = theme.lower().strip()
    if key in THEMES:
        label, subj = THEMES[key]
    else:
        label, subj = theme, [theme, f"{theme}, wide view", f"{theme}, close detail", f"{theme} with soft mist", f"{theme} with sun rays", f"{theme}, peaceful atmosphere"]
    out = []
    for i in range(n):
        s = subj[i % len(subj)]
        l = LIGHT[(i * 3 + i // len(subj)) % len(LIGHT)]
        c = CAMERA[(i * 5 + i // len(subj)) % len(CAMERA)]
        out.append(f"{s} {l}, {c}")
    return label, out

def main():
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument("--tema", required=True, help=f"una din {', '.join(THEMES)} sau text liber")
    p.add_argument("--clipuri", type=int, default=16, help="cate clipuri video (implicit 16)")
    p.add_argument("--durata", type=int, default=8, help="secunde per clip (implicit 8)")
    p.add_argument("--melodii", type=int, default=6, help="cate melodii (implicit 6)")
    p.add_argument("--durata-melodie", type=int, default=150, help="secunde per melodie (implicit 150)")
    p.add_argument("--instrument", default="piano", choices=["piano", "handpan", "guitar", "flute"], help="instrument (implicit piano)")
    p.add_argument("--titlu", default="", help="titlul videoului (doar pentru antet)")
    p.add_argument("--out", default="", help="fisier de iesire .md (implicit prompt-<tema>.md)")
    a = p.parse_args()
    if a.clipuri < 1 or a.melodii < 0 or a.durata < 1:
        sys.exit("clipuri, durata >= 1 si melodii >= 0")
    label, sc = scenes(a.tema, a.clipuri)
    name = a.out or f"prompt-{a.tema.lower().strip().replace(' ', '-')}.md"
    inst = {"piano": "calm piano with soft ambient pads", "handpan": "relaxing handpan melody with soft ambient pads",
            "guitar": "soft acoustic guitar with ambient pads", "flute": "gentle flute with soft ambient pads"}[a.instrument]
    total_clip = a.clipuri * a.durata
    mins = a.durata_melodie // 60; secs = a.durata_melodie % 60
    L = []
    w = L.append
    w(f"# Prompturi Gemini: {a.titlu or label}\n")
    w(f"Tema: **{label}** · {a.clipuri} clipuri x {a.durata} s (~{total_clip // 60} min {total_clip % 60} s unice) · {a.melodii} melodii x ~{mins} min {secs} s ({a.instrument})\n")
    w("Clipurile si muzica generate cu Gemini sunt create cu AI: scrie asta in descriere si bifeaza „Altered content”.\n")
    w("## 1) CLIPURI: lipesti tot blocul de mai jos O SINGURA DATA\n")
    w("Apoi, dupa fiecare clip, scrii doar `next`. Nu mai repeti nimic.\n")
    w("```")
    w(f"You are generating {a.clipuri} separate {a.durata}-second 16:9 horizontal photorealistic nature video clips for a relaxing music channel. Theme: {label}.")
    w("Rules for EVERY clip: no people, no text, no logos, no watermarks, soft natural light, warm vivid colors, calm peaceful mood, no snow, no dark scenes, slow gentle camera movement or a still camera, no fast motion, no cuts inside a clip.")
    w(f"Make exactly ONE clip at a time, in the order below. After each clip, wait until I write \"next\", then make the next one. Do not repeat a scene. Clip numbers must match the list.\n")
    for i, s in enumerate(sc, 1):
        w(f"{i:02d}. {s}")
    w("```\n")
    w("Salveaza clipurile ca " + ", ".join(f"`{i:02d}.mp4`" for i in (1, 2)) + f" … `{a.clipuri:02d}.mp4` in folderul `clipuri/`.\n")
    if a.melodii:
        w("## 2) MUZICA: lipesti blocul O SINGURA DATA, apoi `next`\n")
        w("```")
        w(f"You are generating {a.melodii} separate instrumental tracks, each about {mins} minutes {secs} seconds long, for a relaxing {label} video. Style for all: {inst}, 60-70 BPM, no vocals, no drums, calm, seamless and suitable for looping, every track clearly different in melody from the others.")
        w("Make exactly ONE track at a time, in the order below. After each track, wait until I write \"next\".\n")
        for i in range(a.melodii):
            w(f"{i + 1:02d}. Mood: {MUSIC_MOODS[i % len(MUSIC_MOODS)]}, inspired by {sc[i % len(sc)].split(',')[0]}")
        w("```\n")
        w(f"Salveaza ca `01.mp3` … `{a.melodii:02d}.mp3` in folderul `muzica/`.\n")
    w("## 3) Asamblare (pe calculatorul tau, cu ffmpeg)\n")
    w("```")
    w("SLOW=2 ./build_3h.sh clipuri/ muzica/ video-3h.mp4")
    w("```\n")
    w(f"Cu {a.clipuri} clipuri de {a.durata} s ai ~{total_clip // 60} min {total_clip % 60} s unice; `SLOW=2` le dubleaza. Cu mai multe clipuri video-ul se repeta mai putin vizibil.\n")
    open(name, "w", encoding="utf-8").write("\n".join(L))
    print(f"Scris: {name} ({a.clipuri} clipuri, {a.melodii} melodii)")

if __name__ == "__main__":
    main()
