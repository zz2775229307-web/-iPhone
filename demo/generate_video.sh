#!/usr/bin/env bash
set -euo pipefail

# 目录与参数
ASSETS_DIR="miniprogram/assets"
OUT_DIR="demo"
TMP_DIR="$OUT_DIR/tmp"
RESIZE="750x1334"
DURATION_PER_IMAGE=3  # seconds
TITLE_DURATION=2
VOICE_FILE="$OUT_DIR/voiceover.mp3"
OUTPUT_VIDEO="$OUT_DIR/demo_video_with_audio.mp4"
OUTPUT_VIDEO_NOAUDIO="$OUT_DIR/demo_video_noaudio.mp4"
LIST_FILE="$TMP_DIR/list.txt"

mkdir -p "$OUT_DIR"
rm -rf "$TMP_DIR" && mkdir -p "$TMP_DIR"

# 1) Collect SVG/PNG assets (order matters)
ASSETS=(
  "$ASSETS_DIR/screenshot_index.svg"
  "$ASSETS_DIR/screenshot_watchlist.svg"
  "$ASSETS_DIR/screenshot_detail.svg"
  "$ASSETS_DIR/screenshot_alerts.svg"
  "$ASSETS_DIR/screenshot_chart.svg"
  "$ASSETS_DIR/screenshot_settings.svg"
)

# 2) Convert SVG -> PNG (or copy PNG if already PNG)
echo "Converting SVG -> PNG at $RESIZE ..."
COUNT=0
for src in "${ASSETS[@]}"; do
  if [ -f "$src" ]; then
    ((COUNT++))
    base=$(basename "$src")
    name="img_$(printf "%02d" $COUNT)"
    out="$TMP_DIR/${name}.png"
    # Use ImageMagick to rasterize (transparent background -> white)
    convert -background white -resize $RESIZE "$src" "$out"
    echo " - $src -> $out"
  else
    echo "Warning: asset not found: $src"
  fi
done

# 3) Create title slide
TITLE_PNG="$TMP_DIR/title.png"
convert -size $RESIZE xc:white -gravity Center -pointsize 36 -fill '#111111' -annotate +0-60 '二手 iPhone 市场演示' -pointsize 18 -annotate +0+20 '演示：MVP（mock 数据）' "$TITLE_PNG"

echo "Created title slide: $TITLE_PNG"

# 4) Make short mp4 clips from PNGs
echo "Creating short video clips from PNGs..."
rm -f "$LIST_FILE"
touch "$LIST_FILE"
IDX=0
# Title first
ffmpeg -y -loop 1 -i "$TITLE_PNG" -c:v libx264 -t $TITLE_DURATION -pix_fmt yuv420p -vf "scale=$RESIZE" "$TMP_DIR/clip_$(printf "%02d" $IDX).mp4"
printf "file '%s'\n" "$TMP_DIR/clip_$(printf "%02d" $IDX).mp4" >> "$LIST_FILE"
((IDX++))

for png in "$TMP_DIR"/img_*.png; do
  if [ -f "$png" ]; then
    ffmpeg -y -loop 1 -i "$png" -c:v libx264 -t $DURATION_PER_IMAGE -pix_fmt yuv420p -vf "scale=$RESIZE" "$TMP_DIR/clip_$(printf "%02d" $IDX).mp4"
    printf "file '%s'\n" "$TMP_DIR/clip_$(printf "%02d" $IDX).mp4" >> "$LIST_FILE"
    ((IDX++))
  fi
done

# 5) Concatenate clips
echo "Concatenating clips into $OUTPUT_VIDEO_NOAUDIO ..."
ffmpeg -y -f concat -safe 0 -i "$LIST_FILE" -c copy "$OUTPUT_VIDEO_NOAUDIO"

# 6) If voiceover exists, mix audio and burn subtitles
if [ -f "$VOICE_FILE" ]; then
  echo "Found voiceover: $VOICE_FILE -> merging audio ..."
  # Merge audio (shortest to avoid extra tail)
  ffmpeg -y -i "$OUTPUT_VIDEO_NOAUDIO" -i "$VOICE_FILE" -c:v copy -c:a aac -shortest "$OUT_DIR/tmp_with_audio.mp4"
  # Burn subtitles if subtitles.srt exists
  if [ -f "$OUT_DIR/subtitles.srt" ]; then
    ffmpeg -y -i "$OUT_DIR/tmp_with_audio.mp4" -vf "subtitles=$OUT_DIR/subtitles.srt:force_style='FontName=Arial,FontSize=18'" -c:a copy "$OUTPUT_VIDEO"
    echo "Final video with audio+subtitles: $OUTPUT_VIDEO"
  else
    mv "$OUT_DIR/tmp_with_audio.mp4" "$OUTPUT_VIDEO"
    echo "Final video with audio: $OUTPUT_VIDEO"
  fi
else
  echo "No voiceover found at $VOICE_FILE. Final video without audio: $OUTPUT_VIDEO_NOAUDIO"
fi

echo "Done. Generated files are in $OUT_DIR"
