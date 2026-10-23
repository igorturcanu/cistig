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
    extra = ""
    if d.get("kvk"):
        extra += f'          <dt>KvK</dt>\n          <dd>{esc(d["kvk"])}</dd>\n'
    if d.get("rtv"):
        extra += f'          <dt>Rtv</dt>\n          <dd>{esc(d["rtv"])}</dd>\n'
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
        "extra_contact": extra,
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
