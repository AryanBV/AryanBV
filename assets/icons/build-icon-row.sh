#!/bin/bash
# Generates a composite icon-row SVG: each icon in a rounded dark square.
# Usage: ./build-icon-row.sh <output.svg> <icon1> <icon2> ...
# Requires: simple-icons SVGs at /home/user/AryanBV/assets/icons/<name>.svg

set -euo pipefail

OUTPUT="$1"
shift
ICONS=("$@")

ICON_DIR="/home/user/AryanBV/assets/icons"
BOX=56
GAP=8
PAD=12
SCALE="1.333"  # 32/24 — icon at 32x32 inside 56 box with 12px padding

n=${#ICONS[@]}
width=$((n * BOX + (n - 1) * GAP))

{
  echo "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 ${width} ${BOX}\" width=\"${width}\" height=\"${BOX}\" role=\"img\" aria-label=\"Tech stack icons\">"
  echo "  <style>.bg{fill:#171513;stroke:#2A2520;stroke-width:1}.ic{fill:#F5F5F5}</style>"

  for i in "${!ICONS[@]}"; do
    icon="${ICONS[$i]}"
    x=$((i * (BOX + GAP)))
    path=$(grep -oP 'd="[^"]*"' "${ICON_DIR}/${icon}.svg" | head -1 | sed 's/^d="//;s/"$//')

    if [ -z "$path" ]; then
      echo "ERROR: no path data for $icon" >&2
      exit 1
    fi

    echo "  <g transform=\"translate(${x},0)\">"
    echo "    <rect class=\"bg\" width=\"${BOX}\" height=\"${BOX}\" rx=\"12\"/>"
    echo "    <g transform=\"translate(${PAD},${PAD}) scale(${SCALE})\" class=\"ic\">"
    echo "      <path d=\"${path}\"/>"
    echo "    </g>"
    echo "  </g>"
  done

  echo "</svg>"
} > "$OUTPUT"

echo "Wrote $OUTPUT ($(stat -c%s "$OUTPUT") bytes, $n icons, ${width}x${BOX}px)"
