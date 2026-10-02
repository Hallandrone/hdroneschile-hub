#!/bin/bash
# Vercel build: copy the static site into public/ and fetch the uniform clips (not stored in git).
set -e
rm -rf public && mkdir -p public/media
cp index.html robots.txt sitemap.xml public/
cp -r media/* public/media/
CLIPS_URL="${CLIPS_URL:-https://d2ol7oe51mr4n9.cloudfront.net/user_38qaoD9axM4huuCjrgVvRwEdngr/dbe0c0d4-c000-4bb6-9ea9-fdb81d20ceaf.zip}"
if curl -fsSL -o clips.zip "$CLIPS_URL"; then
  unzip -o -q clips.zip -d public/media && echo "clips: $(ls public/media | wc -l) archivos en media/"
else
  echo "clips: no se pudieron descargar; el sitio usa el clip base"
fi
ls -la public public/media
