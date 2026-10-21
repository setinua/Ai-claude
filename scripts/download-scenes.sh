#!/usr/bin/env bash
# Скачивает 14 картинок (и 4 анимированных клипа) для видео
# "Every Zodiac Sign as a Parent" и называет их по таймкоду начала сцены.
#
# Таймкоды считаются пропорционально количеству слов в каждом блоке озвучки.
# Укажите реальную длину вашей озвучки в секундах (после ускорения):
#   bash download-scenes.sh 482        # например, 8:02
# Без аргумента берётся 480 (8:00).

set -euo pipefail

DURATION="${1:-480}"
OUT="zodiac-scenes"
BASE="https://d8j0ntlcm91z4.cloudfront.net/user_3L03MLwHHnt0yftsvGMzKKk4xec"

# слова в блоке | название | картинка | клип (если есть)
SCENES=(
  "66|Intro|hf_20261021_113158_073a9671-5fc8-4700-a3a2-9c40f0c7f596|"
  "104|Aries|hf_20261021_113156_fdfc1e10-6547-43ba-8357-f1aa48e663bb|"
  "110|Taurus|hf_20261021_113156_1f161e61-603a-47c3-b676-9ff321d9ff1c|hf_20261021_114133_63d6d3b7-f6d7-4559-b30e-0b2a4964c73b"
  "99|Gemini|hf_20261021_113224_c1b7ba42-62b5-4ad1-b432-fbb00c1f1aa8|"
  "108|Cancer|hf_20261021_113224_74515e92-68e2-41d3-bce1-397b40eb3202|"
  "102|Leo|hf_20261021_113156_4ddc84d4-36f7-47aa-b8c8-30d531205142|hf_20261021_114133_039a152a-c3fe-4a8e-8614-0f8c8a1061ef"
  "102|Virgo|hf_20261021_113226_8eb1e72c-782f-4845-8aa3-669061c788af|"
  "94|Libra|hf_20261021_113236_6b6eb8b7-fd7f-4de7-b599-99b32ef8fc7c|"
  "114|Scorpio|hf_20261021_113157_b84b0644-df29-40a3-b594-172e500b9a7a|hf_20261021_114141_f5c6a79d-d4e6-4038-837d-9f8102044848"
  "93|Sagittarius|hf_20261021_113156_32c75867-b4a0-4a8a-8867-8c55794af5f5|"
  "99|Capricorn|hf_20261021_113157_1166148f-9024-47d5-a898-6a745147ed86|"
  "96|Aquarius|hf_20261021_113157_85d47676-261a-4030-b5ba-0e8fb88e3aaf|hf_20261021_114132_c4dcab33-c0ba-4d37-a31a-3b36aea321ff"
  "81|Pisces|hf_20261021_113235_79312318-6f82-41b1-9cdc-580d8eece17b|"
  "39|Final|hf_20261021_113235_fbdea6c3-a3b8-4945-b200-0b9c18f30782|"
)

TOTAL_WORDS=0
for s in "${SCENES[@]}"; do TOTAL_WORDS=$((TOTAL_WORDS + ${s%%|*})); done

mkdir -p "$OUT"
acc=0
n=1
for s in "${SCENES[@]}"; do
  IFS='|' read -r words name img vid <<< "$s"
  sec=$((acc * DURATION / TOTAL_WORDS))
  tc=$(printf "%02d-%02d" $((sec / 60)) $((sec % 60)))
  prefix=$(printf "%02d_%s_%s" "$n" "$tc" "$name")
  echo "$prefix"
  curl -fsSL -o "$OUT/$prefix.png" "$BASE/$img.png"
  if [ -n "$vid" ]; then
    curl -fsSL -o "$OUT/${prefix}_video.mp4" "$BASE/$vid.mp4"
  fi
  acc=$((acc + words))
  n=$((n + 1))
done

curl -fsSL -o "$OUT/00_thumbnail.png" \
  "$BASE/hf_20261021_113704_45f5da98-84fa-48c8-a3ec-468d03315c3e.png"

echo "Готово: папка $OUT"
