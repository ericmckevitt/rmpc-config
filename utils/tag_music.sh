#!/bin/bash

ARTIST="Anderson .Paak"
ALBUM="Oxnard"
DIR="$HOME/Music/mpd/Anderson .Paak/Oxnard"

declare -a TRACKS=(
  "The Chase (feat. Kadhja Bonet)"
  "Headlow (feat. Norelle)"
  "Tints (feat. Kendrick Lamar)"
  "Who R U?"
  "6 Summers"
  "Saviers Road"
  "Smile⧸Petty (feat. Sonyae Elise)"
  "Mansa Musa (feat. Dr. Dre & Cocoa Sarai)"
  "Brother's Keeper (feat. Pusha T)"
  "Anywhere (feat. Snoop Dogg & The Last Artful, Dodgr)"
  "Trippy (feat. J. Cole)"
  "Cheers (feat. Q-Tip)"
  "Sweet Chick (feat. BJ The Chicago Kid)"
  "Left To Right"
)

cd "$DIR" || { echo "❌ Failed to navigate to $DIR"; exit 1; }

# Iterate over the tracks and apply metadata
for i in "${!TRACKS[@]}"; do
  track_num=$((i + 1))
  title="${TRACKS[$i]}"
  filename="$title.mp3"

  if [[ -f "$filename" ]]; then
    echo "✅ Tagging: $filename"
    eyeD3 -a "$ARTIST" -A "$ALBUM" -t "$title" -n "$track_num" "$filename"
  else
    echo "⚠️ File not found: $filename"
  fi
done
