#!/bin/bash
# Day 14 scenario setup — hardware/everyday track: reading `free -h`
# (used vs. free vs. available, and why a low "free" number isn't
# actually a problem), then using ps (day06 skill) to hunt down and
# kill (day06 skill) a real background process that's genuinely
# holding ~300MB of memory. Standalone/no hassan.ali, but calls back
# to the day06 ps/kill muscle memory on purpose.
# Safe to re-run: kills any previous instance, then wipes and rebuilds mission/.

BASE="$(dirname "$0")/mission"

pkill -f "$BASE/opt/session_cache_prewarm.sh" 2>/dev/null
sleep 0.3

rm -rf "$BASE"
mkdir -p "$BASE/opt"

cat > "$BASE/README.txt" <<'EOF'
Someone kicked off a "cache pre-warmer" script that was supposed to run
once and exit. It never exited, and it's been quietly sitting there
holding onto memory ever since.

1. Run `free -h` and get familiar with the columns: total, used, free,
   shared, buff/cache, available. The one that actually matters for
   whether new programs will run smoothly is "available" -- not "free"
   on its own. Linux deliberately keeps recently-used data in
   buff/cache to speed things up, and hands that memory back instantly
   the moment something else actually needs it. So a low "free" number
   next to a healthy "available" number is completely normal, not a
   problem.

2. Figure out what's actually responsible for the memory this mission
   is holding. On a real machine, `ps aux --sort=-%mem` won't
   necessarily put it at the top of the list -- you've likely got a
   browser tab or an IDE using more RAM than this ever will. Instead,
   look for it by name: it's a script living under this mission's
   opt/ folder.

3. Stop it the same way you stopped hassan.ali's rogue process back on
   day06.

4. Run mission/memcheck.sh to confirm it's actually gone.
EOF

cat > "$BASE/opt/session_cache_prewarm.sh" <<'HOGEOF'
#!/bin/bash
# meant to warm a cache once and exit -- never exits
X=$(head -c 314572800 /dev/zero | tr '\0' 'A')
sleep infinity
HOGEOF
chmod +x "$BASE/opt/session_cache_prewarm.sh"

nohup "$BASE/opt/session_cache_prewarm.sh" </dev/null >/dev/null 2>&1 &
disown

cat > "$BASE/memcheck.sh" <<'MCEOF'
#!/bin/bash
DIR="$(dirname "$0")"

if pgrep -f "$DIR/opt/session_cache_prewarm.sh" >/dev/null; then
  echo "[FAIL] session_cache_prewarm.sh is still running -- it's still holding memory."
  exit 1
fi

echo "[OK] no leftover memory-hog process running."
echo "FLAG{memory_freed}"
MCEOF
chmod +x "$BASE/memcheck.sh"

echo "Mission environment built at: $BASE"
echo "A background process from this mission is holding onto memory."
echo "Read mission/README.txt, then investigate with free -h and ps."
