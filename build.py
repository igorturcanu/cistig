#!/usr/bin/env python3
"""Genereert een website, logo en visitekaartje uit template/ en een klantbestand.

Gebruik:  python3 build.py clients/madi-popescu.json
Resultaat: sites/<naam>/  (index.html, style.css, logo.svg, logo-contact.svg, visitekaartje.svg)
"""
import html, json, re, sys
from pathlib import Path

ROOT = Path(__file__).parent
TPL = ROOT / "template"


def fit(name, base, avail):
    """Verklein het lettertype zodat een lange naam niet buiten het logo valt."""
    return round(min(base, avail / (max(len(name), 1) * 0.6)), 1)


def slug(name):
    return re.sub(r"[^a-z0-9]+", "-", name.lower()).strip("-")


def render(text, values):
    for key, val in values.items():
        text = text.replace("{{" + key + "}}", val)
    left = re.findall(r"\{\{(\w+)\}\}", text)
    if left:
        sys.exit(f"Niet ingevulde velden: {sorted(set(left))}")
    return text


def main(path):
    d = json.loads(Path(path).read_text(encoding="utf-8"))
    name = d["name"]
    esc = lambda s: html.escape(s, quote=True)
    role = d["role"]
    languages = f'{d["lang_a"]}–{d["lang_b"]}'
    about = "\n          ".join(f"<p>{esc(p)}</p>" for p in d["about"])
    parts = name.split()
    first = d.get("name_first", " ".join(parts[:-1]))
    last = d.get("name_last", parts[-1])
    name_html = f"{esc(first)} <em>{esc(last)}</em>" if first else f"<em>{esc(last)}</em>"
    navy, gold = d.get("navy", "#14304f"), d.get("gold", "#b08d3c")
    theme_css = f":root{{--navy:{navy};--gold:{gold}}}" if (navy, gold) != ("#14304f", "#b08d3c") else ""

    def rows(items, indent):
        return "".join(f'{indent}<dt>{esc(k)}</dt>\n{indent}<dd>{esc(v)}</dd>\n' for k, v in items)

    facts = d.get("facts") or [
        ("Beroep", role[:1].upper() + role[1:]),
        ("Taalcombinatie", languages),
        ("Voor", "Rechtbanken, advocaten, politie, gemeenten en particulieren"),
        ("Uitgangspunt", "Nauwkeurig, onpartijdig en strikt vertrouwelijk"),
    ]
    reg = [("Beroep", role[:1].upper() + role[1:]), ("Taalcombinatie", languages)]
    if d.get("rtv"):
        reg.append(("Rtv-inschrijfnummer", d["rtv"]))
    if d.get("kvk"):
        reg.append(("KvK-nummer", d["kvk"]))
    phone = d["phone"]
    v = {
        "name": esc(name),
        "initials": esc(d["initials"]),
        "role": esc(role),
        "role_cap": esc(role[:1].upper() + role[1:]),
        "role_short": esc(d.get("role_short", "TOLK & VERTALER")),
        "languages": esc(languages),
        "languages_caps": esc(f'{d["lang_a"]} · {d["lang_b"]}'.upper()),
        "lang_codes": esc(d.get("lang_codes", "")),
        "lang_a": esc(d["lang_a"]),
        "lang_b": esc(d["lang_b"]),
        "email": esc(d["email"]),
        "phone": esc(phone),
        "phone_tel": re.sub(r"[^+\d]", "", phone),
        "about_html": about,
        "name_html": name_html,
        "facts_html": rows(facts, " " * 12),
        "reg_html": rows(reg, " " * 14),
        "theme_css": theme_css,
        "navy": navy,
        "gold": "#d9a441" if gold == "#b08d3c" else gold,
        "name_size_logo": str(fit(name, 32, 246)),
        "name_size_contact": str(fit(name, 35, 278)),
        "name_size_card": str(fit(name, 64, 570)),
    }
    out = ROOT / "sites" / slug(name)
    out.mkdir(parents=True, exist_ok=True)
    files = {
        "index.html.tpl": "index.html",
        "logo.svg.tpl": "logo.svg",
        "logo-contact.svg.tpl": "logo-contact.svg",
        "visitekaartje.svg.tpl": "visitekaartje.svg",
    }
    for src, dst in files.items():
        text = (TPL / src).read_text(encoding="utf-8")
        (out / dst).write_text(render(text, v), encoding="utf-8")
    (out / "style.css").write_text((TPL / "style.css").read_text(encoding="utf-8"), encoding="utf-8")
    print(f"Klaar: {out}")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    main(sys.argv[1])
