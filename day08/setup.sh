#!/bin/bash
# Day 8 scenario setup — Hassan Ali's cron persistence is dead (day 7), but
# the watcher's old log mentioned "phoning home." Something is still
# listening on a local port, waiting for instructions. For ss / netstat and
# lsof -i (find the socket), ps (trace the PID back to its script), and nc
# (speak to it once you know the protocol).
# Safe to re-run: kills any previous instance, then wipes and rebuilds mission/.

BASE="$(dirname "$0")/mission"

pkill -f "$BASE/" 2>/dev/null
sleep 0.2

rm -rf "$BASE"
mkdir -p "$BASE/opt"

PORT=$((30000 + RANDOM % 5000))

cat > "$BASE/opt/beacon.sh" <<'EOF'
#!/bin/bash
DIR="$(dirname "$0")"
LOG="$DIR/beacon.log"
FLAG_FILE="$DIR/../recovered.flag"
PORT="$1"

echo "$(date +%T) beacon started on 127.0.0.1:$PORT, pid $$" >> "$LOG"

while true; do
  banner="hassan.ali's beacon online. send a command:"
  cmd=$(printf '%s\n' "$banner" | nc -l -p "$PORT")
  cmd="${cmd%$'\r'}"
  if [[ "$cmd" == "SHUTDOWN" ]]; then
    echo "$(date +%T) SHUTDOWN received - beacon going dark for good" >> "$LOG"
    echo "FLAG{beacon_silenced}" > "$FLAG_FILE"
    exit 0
  else
    echo "$(date +%T) unrecognized input: '${cmd:-<empty>}' - beacon still listening" >> "$LOG"
  fi
done
EOF
chmod +x "$BASE/opt/beacon.sh"

nohup "$BASE/opt/beacon.sh" "$PORT" >/dev/null 2>&1 &
disown

echo "Mission environment built at: $BASE"
echo "Something on this machine is listening on a local port, left behind by"
echo "hassan.ali's process. Find it, figure out how to talk to it, and shut"
echo "it down for good."
