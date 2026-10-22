#!/usr/bin/env node
// Generate the images for one Short (single theme: calm morning oasis) with the
// Gemini API, pausing between requests so the free-tier rate limit is not hit.
//
// Usage:
//   GEMINI_API_KEY=your_key node tools/generate_images.mjs [outputDir]
//
// Optional environment variables:
//   GEMINI_IMAGE_MODEL  image model name (default below; check Google's docs for the current one)
//   DELAY_MS            pause between requests in ms (default 15000)
//   ASPECT_RATIO        e.g. "9:16". Sent to the API only if set; the prompts already ask
//                       for vertical images and make_short.sh crops to 1080x1920 anyway.
//   DRY_RUN=1           print what would be sent, call nothing
//
// Images that already exist in the output folder are skipped, so you can re-run
// the script after an error and it continues where it stopped.
import { mkdir, writeFile, access } from 'node:fs/promises';
import path from 'node:path';

const API_KEY = process.env.GEMINI_API_KEY;
const MODEL = process.env.GEMINI_IMAGE_MODEL || 'gemini-2.5-flash-image';
const DELAY_MS = Number(process.env.DELAY_MS || 15000);
const ASPECT_RATIO = process.env.ASPECT_RATIO || '';
const DRY_RUN = process.env.DRY_RUN === '1';
const OUT_DIR = process.argv[2] || 'images/morning-oasis';
const MAX_ATTEMPTS = 4;

const STYLE =
  'vertical 9:16 composition, soft golden morning light, calm and serene, photorealistic, ' +
  'peaceful relaxing atmosphere, no people, no text, no watermark';

// One theme: a quiet oasis at sunrise. One scene per image, in video order.
const SCENES = [
  'A still oasis pond at sunrise surrounded by palm trees, mist on the water',
  'Golden sunlight breaking through palm leaves over calm turquoise water',
  'Soft desert dunes at dawn behind a small green oasis, warm pink sky',
  'Close-up of morning dew on green leaves beside a quiet pool, gentle light',
  'A lone palm tree reflected in perfectly still water at sunrise',
  'Wide view of the oasis in warm morning haze, birds far in the sky',
];

const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));
const exists = (file) => access(file).then(() => true, () => false);

async function requestImage(prompt) {
  const generationConfig = { responseModalities: ['TEXT', 'IMAGE'] };
  if (ASPECT_RATIO) generationConfig.imageConfig = { aspectRatio: ASPECT_RATIO };

  const url = `https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent`;
  const response = await fetch(url, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', 'x-goog-api-key': API_KEY },
    body: JSON.stringify({ contents: [{ parts: [{ text: prompt }] }], generationConfig }),
  });

  if (!response.ok) {
    const error = new Error(`HTTP ${response.status}: ${(await response.text()).slice(0, 300)}`);
    error.status = response.status;
    throw error;
  }

  const data = await response.json();
  const parts = data.candidates?.[0]?.content?.parts ?? [];
  const image = parts.map((p) => p.inlineData ?? p.inline_data).find((d) => d?.data);
  if (!image) {
    const text = parts.map((p) => p.text).filter(Boolean).join(' ');
    throw new Error(`No image in the response${text ? `: ${text.slice(0, 200)}` : ''}`);
  }
  const mime = image.mimeType ?? image.mime_type ?? 'image/png';
  return { buffer: Buffer.from(image.data, 'base64'), ext: mime.includes('jpeg') ? 'jpg' : 'png' };
}

async function generateWithRetry(prompt) {
  for (let attempt = 1; ; attempt++) {
    try {
      return await requestImage(prompt);
    } catch (error) {
      const retryable = error.status === 429 || error.status >= 500 || error.status === undefined;
      if (!retryable || attempt >= MAX_ATTEMPTS) throw error;
      const wait = DELAY_MS * attempt;
      console.warn(`  ${error.message}\n  Waiting ${wait / 1000}s, then retrying (${attempt}/${MAX_ATTEMPTS - 1})`);
      await sleep(wait);
    }
  }
}

async function main() {
  if (!API_KEY && !DRY_RUN) {
    console.error('Set GEMINI_API_KEY first (create a key in Google AI Studio).');
    process.exit(1);
  }
  await mkdir(OUT_DIR, { recursive: true });

  for (const [index, scene] of SCENES.entries()) {
    const name = `scene-${String(index + 1).padStart(2, '0')}`;
    const prompt = `${scene}, ${STYLE}`;

    if ((await exists(path.join(OUT_DIR, `${name}.png`))) || (await exists(path.join(OUT_DIR, `${name}.jpg`)))) {
      console.log(`${name}: already exists, skipping`);
      continue;
    }
    if (DRY_RUN) {
      console.log(`${name} [${MODEL}]: ${prompt}`);
      continue;
    }

    console.log(`${name}: generating...`);
    const { buffer, ext } = await generateWithRetry(prompt);
    const file = path.join(OUT_DIR, `${name}.${ext}`);
    await writeFile(file, buffer);
    console.log(`${name}: saved ${file}`);

    if (index < SCENES.length - 1) {
      console.log(`  pausing ${DELAY_MS / 1000}s...`);
      await sleep(DELAY_MS);
    }
  }
  console.log(`Done. Images are in ${OUT_DIR}`);
}

main().catch((error) => {
  console.error(error.message);
  process.exit(1);
});
