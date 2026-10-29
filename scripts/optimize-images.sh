#!/usr/bin/env bash
# Resize post images to at most 1600 px on the longest side and recompress, in place.
# Uses ImageMagick if installed (also strips metadata such as GPS), otherwise macOS sips.
#
# Usage: scripts/optimize-images.sh assets/img/posts/<post-slug> [more dirs or files]
set -euo pipefail

MAX=1600
QUALITY=82

if [ $# -eq 0 ]; then
  echo "usage: $0 <dir|file>..." >&2
  exit 1
fi

if command -v magick >/dev/null 2>&1; then
  IM=magick
elif command -v convert >/dev/null 2>&1; then
  IM=convert
else
  IM=""
fi

find "$@" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) -print0 |
  while IFS= read -r -d '' f; do
    before=$(wc -c < "$f")
    if [ -n "$IM" ]; then
      "$IM" "$f" -resize "${MAX}x${MAX}>" -strip -quality "$QUALITY" "$f"
    else
      w=$(sips -g pixelWidth "$f" | awk '/pixelWidth/ {print $2}')
      h=$(sips -g pixelHeight "$f" | awk '/pixelHeight/ {print $2}')
      if [ "$w" -gt "$MAX" ] || [ "$h" -gt "$MAX" ]; then
        sips -Z "$MAX" "$f" >/dev/null
      fi
      case "$f" in
        *.jpg|*.jpeg|*.JPG|*.JPEG) sips -s formatOptions "$QUALITY" "$f" >/dev/null ;;
      esac
    fi
    after=$(wc -c < "$f")
    echo "$f: $((before / 1024)) KB -> $((after / 1024)) KB"
  done
