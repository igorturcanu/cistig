#!/usr/bin/env python3
"""Verifică dacă site-urile tale răspund și, opțional, statisticile publice
ale unui canal YouTube (YouTube Data API v3).

Ieșirea este în formatul "local check" din Checkmk:
    <status> <nume_serviciu> <metrici|-> <text>
    status: 0=OK, 1=WARN, 2=CRIT

Utilizare:
    python3 check_sites.py https://exemplu.ro https://alt-site.ro
    YT_API_KEY=... YT_CHANNEL_ID=UCxxxx python3 check_sites.py

Pentru Checkmk: copiază scriptul în /usr/lib/check_mk_agent/local/ și fă-l executabil.
"""
import json
import os
import sys
import time
import urllib.error
import urllib.parse
import urllib.request

WARN_SECONDS = 2.0
TIMEOUT = 10


def check_url(url):
    name = "Site_" + urllib.parse.urlparse(url).netloc.replace(".", "_")
    start = time.monotonic()
    try:
        with urllib.request.urlopen(url, timeout=TIMEOUT) as resp:
            code = resp.status
    except urllib.error.HTTPError as e:
        code = e.code
    except Exception as e:  # DNS, timeout, TLS etc.
        print(f"2 {name} - NU răspunde: {e}")
        return
    elapsed = time.monotonic() - start
    if code >= 400:
        status = 2
    elif elapsed > WARN_SECONDS:
        status = 1
    else:
        status = 0
    print(f"{status} {name} time={elapsed:.3f}s HTTP {code} în {elapsed:.2f}s")


def check_youtube(api_key, channel_id):
    qs = urllib.parse.urlencode(
        {"part": "statistics", "id": channel_id, "key": api_key}
    )
    url = f"https://www.googleapis.com/youtube/v3/channels?{qs}"
    try:
        with urllib.request.urlopen(url, timeout=TIMEOUT) as resp:
            data = json.load(resp)
        stats = data["items"][0]["statistics"]
    except Exception as e:
        print(f"2 YouTube_canal - Eroare API: {e}")
        return
    views = int(stats.get("viewCount", 0))
    subs = int(stats.get("subscriberCount", 0))
    videos = int(stats.get("videoCount", 0))
    print(
        f"0 YouTube_canal views={views}|subs={subs}|videos={videos} "
        f"{views} vizionări, {subs} abonați, {videos} videoclipuri"
    )


def main():
    for url in sys.argv[1:]:
        check_url(url)
    key, channel = os.environ.get("YT_API_KEY"), os.environ.get("YT_CHANNEL_ID")
    if key and channel:
        check_youtube(key, channel)


if __name__ == "__main__":
    main()
