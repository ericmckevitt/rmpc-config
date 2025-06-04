#!/bin/bash

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <path-to-album-directory>"
  exit 1
fi

DIR="$1"

cd "$DIR" || { echo "❌ Failed to navigate to $DIR"; exit 1; }

# Get all mp3s sorted by eyeD3 track number
FILES=()
while IFS= read -r line; do
  FILES+=("$line")
done < <(
  for f in *.mp3; do
    track_num=$(eyeD3 "$f" 2>/dev/null | grep -i "^track:" | awk '{print $2}' | cut -d/ -f1)
    printf "%03d|%s\n" "${track_num:-999}" "$f"
  done | sort | cut -d'|' -f2
)

for file in "${FILES[@]}"; do
  [[ -f "$file" ]] || continue

  echo ""
  echo "🎵 Now tagging: $file"
  eyeD3 "$file" | grep -Ei "title:|track:|genre:"

  read -rp "Enter genre(s) for this track (comma-separated): " genre

  if [[ -n "$genre" ]]; then
    eyeD3 --genre="$genre" "$file"
    echo "✅ Set genre to: $genre"
  else
    echo "⏭️  Skipped (no genre entered)"
  fi
done
