#!/usr/bin/env bash
set -euo pipefail

OUT_DIR="${1:-pdfs}"
mkdir -p "$OUT_DIR"

shopt -s nullglob
files=(*.md)
shopt -u nullglob

if [ ${#files[@]} -eq 0 ]; then
  echo "No .md files found"
  exit 1
fi

count=0
for md in "${files[@]}"; do
  [ "$md" = "README.md" ] && continue

  name="${md%.md}"
  pdf="$OUT_DIR/$name.pdf"

  echo "Converting: $md -> $pdf"
  pandoc "$md" \
    --pdf-engine=xelatex \
    -V mainfont="DejaVu Sans" \
    -V monofont="DejaVu Sans Mono" \
    -V geometry:margin=2cm \
    -V fontsize=11pt \
    -V documentclass=article \
    -V toc=true \
    -V toc-depth=3 \
    -o "$pdf"

  count=$((count + 1))
done

echo "Done: $count PDFs generated in $OUT_DIR"
