#!/bin/bash
# Day 6 scenario setup — a rogue background process left running (Hassan Ali
# case continues), for ps / kill / top / jobs / bg / fg practice.
# Safe to re-run: kills any previous instance, then wipes and rebuilds mission/.

BASE="$(dirname "$0")/mission"

pkill -f "$BASE/rogue_watcher.sh" 2>/dev/null
sleep 0.2

rm -rf "$BASE"
mkdir -p "$BASE"

cat > "$BASE/rogue_watcher.sh" <<'EOF'
#!/bin/bash
LOG="$(dirname "$0")/watcher.log"
FLAG_FILE="$(dirname "$0")/recovered.flag"

cleanup() {
  echo "$(date +%T) received SIGTERM - shutting down cleanly" >> "$LOG"
  echo "FLAG{graceful_shutdown_sigterm}" > "$FLAG_FILE"
  exit 0
}
trap cleanup SIGTERM

echo "$(date +%T) rogue_watcher started, pid $$" >> "$LOG"
while true; do
  echo "$(date +%T) heartbeat - unauthorized leftover process (owner: hassan.ali)" >> "$LOG"
  sleep 3
done
EOF
chmod +x "$BASE/rogue_watcher.sh"

nohup "$BASE/rogue_watcher.sh" >/dev/null 2>&1 &
disown

echo "Mission environment built at: $BASE"
echo "A rogue background process is now running and will not stop on its own."
