#!/bin/bash
# Day 10 scenario setup — an everyday disk-space crisis, no rogue actor this
# time. The mission/ home directory is over its storage quota and backups
# are failing. Find what's eating the space (du, ls -lhS) and clean up
# enough junk to get back under quota — without deleting anything you
# actually need.
# Safe to re-run: wipes and rebuilds mission/.

BASE="$(dirname "$0")/mission"

rm -rf "$BASE"
mkdir -p "$BASE/Downloads" "$BASE/.cache/browser" "$BASE/.cache/thumbnails" "$BASE/logs" "$BASE/Documents"

cat > "$BASE/README.txt" <<'EOF'
Your home directory is over its 300MB storage quota and nightly backups
have started failing. Track down what's using the space and clean up
enough of it to get back under quota — but don't lose anything you'd
actually miss.

Run ./check_space.sh anytime to see where you stand.
EOF

# --- junk: old download, safe to delete ---
fallocate -l 220M "$BASE/Downloads/movie_backup_old.mp4"
fallocate -l 80M  "$BASE/Downloads/installer_setup_v1.dmg"

# --- keep: real files ---
fallocate -l 8M "$BASE/Downloads/family_vacation.tar"
fallocate -l 12M "$BASE/Documents/taxes_2024.pdf"
fallocate -l 1M  "$BASE/Documents/resume.docx"

# --- junk: regenerable caches ---
fallocate -l 60M "$BASE/.cache/browser/cache.dat"
fallocate -l 25M "$BASE/.cache/thumbnails/thumb.db"

# --- keep: current log ---
fallocate -l 3M "$BASE/logs/app.log"

# --- junk: old rotated logs ---
fallocate -l 30M "$BASE/logs/app.log.1"
fallocate -l 30M "$BASE/logs/app.log.2"

cat > "$BASE/check_space.sh" <<'CHECKEOF'
#!/bin/bash
DIR="$(dirname "$0")"
LIMIT_MB=300
LIMIT_BYTES=$((LIMIT_MB * 1024 * 1024))

USED_BYTES=$(du -sb "$DIR" | cut -f1)
USED_HUMAN=$(du -sh "$DIR" | cut -f1)

KEEP_FILES=(
  "Downloads/family_vacation.tar"
  "Documents/taxes_2024.pdf"
  "Documents/resume.docx"
  "logs/app.log"
)

missing=()
for f in "${KEEP_FILES[@]}"; do
  [ -f "$DIR/$f" ] || missing+=("$f")
done

echo "Current usage: $USED_HUMAN (quota: ${LIMIT_MB}M)"

if [ "${#missing[@]}" -gt 0 ]; then
  echo "Warning: missing file(s) you were supposed to keep:"
  for f in "${missing[@]}"; do
    echo "  - $f"
  done
  exit 1
fi

if [ "$USED_BYTES" -le "$LIMIT_BYTES" ]; then
  echo "Under quota. Backups will run tonight."
  echo "FLAG{quota_cleared}"
else
  OVER_MB=$(( (USED_BYTES - LIMIT_BYTES) / 1024 / 1024 ))
  echo "Still over quota by about ${OVER_MB}M. Keep looking."
  exit 1
fi
CHECKEOF
chmod +x "$BASE/check_space.sh"

echo "Mission environment built at: $BASE"
echo "The home directory under mission/ is over its 300MB quota. Find the"
echo "space hogs and clean up enough of them to pass mission/check_space.sh"
echo "— without deleting anything you'd actually need."
