#!/bin/bash
# Day 12 scenario setup — hardware/everyday track: reading df-style
# "which volume is nearly full" output, then drilling in with du (day10)
# to find and clean the offender. Standalone/no hassan.ali, per the
# day10 "everyday" preference.
# Safe to re-run: wipes and rebuilds mission/.

BASE="$(dirname "$0")/mission"

rm -rf "$BASE"
mkdir -p "$BASE/volumes/logs" "$BASE/volumes/uploads/thumbnail_cache" "$BASE/volumes/uploads/old_exports" "$BASE/volumes/uploads/active_uploads" "$BASE/volumes/database"

cat > "$BASE/README.txt" <<'EOF'
Three shared volumes on this box are monitored for space: logs, uploads,
and database. Something is filling one of them up.

First, get your bearings on your real machine:

  df -h

That's the whole-disk view -- every mounted filesystem, its size, how
much is used, and how much is left. (Contrast that with `du`, which you
used on day10 -- du only measures *inside one folder*.)

This mission's three volumes are simulated under mission/volumes/, since
we can't safely mount and fill real partitions for a drill. Run:

  ./mission/diskcheck.sh

It prints a df-style table for the three volumes. Find the one in WARN
state, go investigate it with the tools you already know (du, ls -lahS),
clean out what's safe to delete, and re-run diskcheck.sh until everything
passes.
EOF

# --- logs volume: healthy, just a red herring row ---
fallocate -l 40M "$BASE/volumes/logs/old_app.log.1"
fallocate -l 35M "$BASE/volumes/logs/old_app.log.2"
fallocate -l 30M "$BASE/volumes/logs/current_app.log"

# --- uploads volume: over quota, junk mixed with a keep file ---
fallocate -l 60M "$BASE/volumes/uploads/thumbnail_cache/cache.dat"
fallocate -l 50M "$BASE/volumes/uploads/old_exports/export_2024_backup.zip"
fallocate -l 30M "$BASE/volumes/uploads/active_uploads/current_batch.dat"

# --- database volume: healthy, another red herring row ---
fallocate -l 120M "$BASE/volumes/database/db_current.db"

cat > "$BASE/diskcheck.sh" <<'DCEOF'
#!/bin/bash
DIR="$(dirname "$0")/volumes"

# name:quota_in_MB
VOLUMES="logs:150 uploads:150 database:500"

printf "%-10s %6s %6s %6s %6s   %s\n" "VOLUME" "SIZE" "USED" "AVAIL" "USE%" "STATUS"

FAIL=0
for entry in $VOLUMES; do
  NAME="${entry%%:*}"
  QUOTA="${entry##*:}"
  USED=$(du -sm "$DIR/$NAME" 2>/dev/null | cut -f1)
  AVAIL=$((QUOTA - USED))
  PCT=$((USED * 100 / QUOTA))
  STATUS="OK"
  if [ "$PCT" -ge 90 ]; then
    STATUS="WARN"
    FAIL=1
  fi
  printf "%-10s %5sM %5sM %5sM %5s%%   %s\n" "$NAME" "$QUOTA" "$USED" "$AVAIL" "$PCT" "$STATUS"
done

if [ ! -f "$DIR/uploads/active_uploads/current_batch.dat" ]; then
  echo
  echo "[FAIL] active_uploads/current_batch.dat is missing -- that's live data, don't delete it!"
  exit 1
fi

if [ "$FAIL" -eq 1 ]; then
  echo
  echo "[FAIL] one or more volumes are over quota (WARN above)."
  exit 1
fi

echo
echo "[OK] all volumes under quota."
echo "FLAG{volumes_under_quota}"
DCEOF
chmod +x "$BASE/diskcheck.sh"

echo "Mission environment built at: $BASE"
echo "Read mission/README.txt, then run mission/diskcheck.sh to see the problem."
