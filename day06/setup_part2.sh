#!/bin/bash
# Day 6, part 2 — "needle in the haystack". Several background processes are
# running with plausible, boring names. One of them is not where it should be.
# The lesson: don't trust the process name, check where it actually runs from.
# Safe to re-run: kills any previous instances, then wipes and rebuilds mission_part2/.

BASE="$(dirname "$0")/mission_part2"

pkill -f "$BASE/" 2>/dev/null
sleep 0.2

rm -rf "$BASE"
mkdir -p "$BASE/opt"
mkdir -p "$BASE/var/tmp/.cache"

make_decoy() {
  local path="$1" label="$2"
  cat > "$path" <<EOF
#!/bin/bash
LOG="\$(dirname "\$0")/$label.log"
while true; do
  echo "\$(date +%T) $label heartbeat - all normal" >> "\$LOG"
  sleep 3
done
EOF
  chmod +x "$path"
}

make_decoy "$BASE/opt/log-rotate-helper.sh" "log-rotate-helper"
make_decoy "$BASE/opt/metrics-agent.sh" "metrics-agent"
make_decoy "$BASE/opt/backup-sync.sh" "backup-sync"

cat > "$BASE/var/tmp/.cache/system-health-check.sh" <<'EOF'
#!/bin/bash
LOG="$(dirname "$0")/system-health-check.log"
FLAG_FILE="$(dirname "$0")/../../../recovered_part2.flag"

cleanup() {
  echo "$(date +%T) received SIGTERM - shutting down cleanly" >> "$LOG"
  echo "FLAG{path_not_name_reveals_rogue}" > "$FLAG_FILE"
  exit 0
}
trap cleanup SIGTERM

echo "$(date +%T) system-health-check started, pid $$" >> "$LOG"
while true; do
  echo "$(date +%T) heartbeat - unauthorized process (owner: hassan.ali)" >> "$LOG"
  sleep 3
done
EOF
chmod +x "$BASE/var/tmp/.cache/system-health-check.sh"

for f in "$BASE/opt/log-rotate-helper.sh" "$BASE/opt/metrics-agent.sh" "$BASE/opt/backup-sync.sh" "$BASE/var/tmp/.cache/system-health-check.sh"; do
  nohup "$f" >/dev/null 2>&1 &
  disown
done

echo "Mission environment built at: $BASE"
echo "4 background processes are now running. One of them doesn't belong."
echo "This time the name won't help you."
