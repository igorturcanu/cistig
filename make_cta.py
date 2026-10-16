#!/usr/bin/env python3
"""Generează imaginea transparentă (1920x1080) cu butoanele SUBSCRIBE / LIKE / SHARE,
avatarul canalului și textul de dedesubt. build_video.sh o suprapune peste video
la început, la mijloc și la sfârșit.

Utilizare:
    python3 make_cta.py --channel "Sounds and Dreamscapes" --logo logo.jpg --out assets/cta.png

Necesită Pillow (pip install pillow). Pentru pictogramele clopoțel și degetul mare
folosește fontul Noto Color Emoji, dacă există pe sistem; altfel le desenează simplu.
"""
import argparse
import os

from PIL import Image, ImageDraw, ImageFilter, ImageFont

W, H = 1920, 1080
S = 2  # supraeșantionare pentru margini netede

FONT_CANDIDATES = [
    "/usr/share/fonts/truetype/liberation/LiberationSans-Bold.ttf",
    "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
    "/usr/share/fonts/dejavu/DejaVuSans-Bold.ttf",
    "/usr/share/fonts/TTF/DejaVuSans-Bold.ttf",
    "/System/Library/Fonts/Supplemental/Arial Bold.ttf",
    "/Library/Fonts/Arial Bold.ttf",
    "C:/Windows/Fonts/arialbd.ttf",
]
EMOJI_CANDIDATES = [
    "/usr/share/fonts/truetype/noto/NotoColorEmoji.ttf",
    "/usr/share/fonts/noto/NotoColorEmoji.ttf",
]


def find(paths):
    for p in paths:
        if os.path.isfile(p):
            return p
    return None


def font(size):
    path = find(FONT_CANDIDATES)
    return ImageFont.truetype(path, size * S) if path else ImageFont.load_default()


def emoji_mask(char, size):
    """Silueta (mască alfa) a unui emoji, sau None dacă fontul lipsește."""
    path = find(EMOJI_CANDIDATES)
    if not path:
        return None
    f = ImageFont.truetype(path, 109)
    tile = Image.new("RGBA", (136, 128), (0, 0, 0, 0))
    ImageDraw.Draw(tile).text((0, 0), char, font=f, embedded_color=True)
    tile = tile.crop(tile.getbbox())
    ratio = size / max(tile.size)
    tile = tile.resize((max(1, round(tile.width * ratio)), max(1, round(tile.height * ratio))), Image.LANCZOS)
    return tile.getchannel("A")


def paste_mask(img, mask, xy, color):
    layer = Image.new("RGBA", mask.size, color)
    img.paste(layer, xy, mask)


def draw_bell_fallback(d, cx, cy, r, color):
    d.pieslice((cx - r, cy - r, cx + r, cy + r), 180, 360, fill=color)
    d.rectangle((cx - r, cy, cx + r, cy + r * 0.7), fill=color)
    d.ellipse((cx - r * 0.35, cy + r * 0.7, cx + r * 0.35, cy + r * 1.2), fill=color)


def draw_share(d, cx, cy, r, color):
    p = [(cx - r, cy), (cx + r * 0.8, cy - r * 0.9), (cx + r * 0.8, cy + r * 0.9)]
    d.line([p[0], p[1]], fill=color, width=int(r * 0.22))
    d.line([p[0], p[2]], fill=color, width=int(r * 0.22))
    for x, y in p:
        d.ellipse((x - r * 0.42, y - r * 0.42, x + r * 0.42, y + r * 0.42), fill=color)


def pill(img, d, x, y, h, label, fill, fg, icon):
    f = font(int(h / S * 0.46))
    tw = d.textlength(label, font=f)
    icon_size = int(h * 0.52)
    pad = int(h * 0.38)
    gap = int(h * 0.16)
    w = int(pad + icon_size + gap + tw + pad)
    d.rounded_rectangle((x, y, x + w, y + h), radius=h // 2, fill=fill)
    ix, iy = x + pad, y + (h - icon_size) // 2
    cx, cy = ix + icon_size // 2, iy + icon_size // 2
    if icon == "bell":
        m = emoji_mask("🔔", icon_size)
        if m:
            paste_mask(img, m, (ix, iy + (icon_size - m.height) // 2), fg)
        else:
            draw_bell_fallback(d, cx, cy - icon_size // 6, icon_size // 2, fg)
    elif icon == "like":
        m = emoji_mask("👍", icon_size)
        if m:
            paste_mask(img, m, (ix, iy + (icon_size - m.height) // 2), fg)
        else:
            d.rounded_rectangle((ix, cy, ix + icon_size * 0.3, iy + icon_size), radius=6, fill=fg)
            d.rounded_rectangle((ix + icon_size * 0.38, cy - icon_size * 0.1, ix + icon_size, iy + icon_size), radius=14, fill=fg)
    else:
        draw_share(d, cx, cy, icon_size // 2, fg)
    d.text((ix + icon_size + gap, y + h / 2), label, font=f, fill=fg, anchor="lm")
    return w


def avatar(logo, size, ring=False):
    im = Image.open(logo).convert("RGB")
    s = min(im.size)
    im = im.crop(((im.width - s) // 2, (im.height - s) // 2, (im.width + s) // 2, (im.height + s) // 2))
    im = im.resize((size, size), Image.LANCZOS)
    mask = Image.new("L", (size, size), 0)
    ImageDraw.Draw(mask).ellipse((0, 0, size - 1, size - 1), fill=255)
    out = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    out.paste(im, (0, 0), mask)
    if ring:
        ImageDraw.Draw(out).ellipse((0, 0, size - 1, size - 1), outline=(255, 255, 255, 255), width=max(3, size // 28))
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--channel", default="Canalul Meu")
    ap.add_argument("--tagline", default="Subscribe, Like & Share with friends")
    ap.add_argument("--logo", help="imagine pentru avatarul rotund (se decupează pătrat)")
    ap.add_argument("--ring", action="store_true", help="adaugă un inel alb în jurul avatarului")
    ap.add_argument("--out", default="assets/cta.png")
    a = ap.parse_args()

    img = Image.new("RGBA", (W * S, H * S), (0, 0, 0, 0))

    # Degrade întunecat jos, pentru lizibilitate.
    grad = Image.new("RGBA", (W * S, H * S), (0, 0, 0, 0))
    gd = ImageDraw.Draw(grad)
    top = int(H * 0.62 * S)
    for y in range(top, H * S):
        alpha = int(150 * (y - top) / (H * S - top))
        gd.line([(0, y), (W * S, y)], fill=(0, 0, 0, alpha))
    img.alpha_composite(grad)

    d = ImageDraw.Draw(img)
    h = 96 * S
    row_y = 765 * S
    gap = 24 * S
    av = 132 * S

    # Calculează lățimea rândului ca să-l centrăm.
    probe = Image.new("RGBA", (10, 10))
    pd = ImageDraw.Draw(probe)

    def pill_width(label):
        f = font(int(h / S * 0.46))
        return int(h * 0.38 * 2 + h * 0.52 + h * 0.16 + pd.textlength(label, font=f))

    widths = [pill_width("SUBSCRIBE"), pill_width("LIKE"), pill_width("SHARE")]
    total = (av + gap if a.logo else 0) + sum(widths) + gap * 2
    x = (W * S - total) // 2

    if a.logo:
        img.alpha_composite(avatar(a.logo, av, a.ring), (x, row_y + (h - av) // 2))
        x += av + gap
    red, white, black = (232, 62, 38, 255), (250, 250, 250, 255), (20, 20, 20, 255)
    x += pill(img, d, x, row_y, h, "SUBSCRIBE", red, (255, 255, 255, 255), "bell") + gap
    x += pill(img, d, x, row_y, h, "LIKE", white, black, "like") + gap
    pill(img, d, x, row_y, h, "SHARE", white, black, "share")

    # Text sub butoane, cu umbră.
    shadow = Image.new("RGBA", img.size, (0, 0, 0, 0))
    sd = ImageDraw.Draw(shadow)
    lines = [(a.channel, 66, 905), (a.tagline, 46, 975)]
    for text, size, cy in lines:
        sd.text((W * S // 2 + 3 * S, cy * S + 3 * S), text, font=font(size), fill=(0, 0, 0, 200), anchor="mm")
    img.alpha_composite(shadow.filter(ImageFilter.GaussianBlur(4 * S)))
    for text, size, cy in lines:
        d.text((W * S // 2, cy * S), text, font=font(size), fill=(255, 255, 255, 255), anchor="mm")

    out_dir = os.path.dirname(a.out)
    if out_dir:
        os.makedirs(out_dir, exist_ok=True)
    img.resize((W, H), Image.LANCZOS).save(a.out)
    print("Salvat:", a.out)


if __name__ == "__main__":
    main()
