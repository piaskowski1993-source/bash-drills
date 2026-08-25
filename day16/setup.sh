#!/bin/bash
# Day 16 scenario setup — scripting track, second for-loop rep (per user
# request to consolidate loops before while loops). Same review-skills
# shape as day15 (grep/if/mv inside a for loop) but this time the user
# writes the ENTIRE script from scratch (no shebang/DIR/loop skeleton
# given -- process_sensors.sh starts as an empty executable file), plus
# one new small piece: a counter/tally pattern ($((count+1))) to total
# up results and write a summary file. Standalone/no hassan.ali.
# Safe to re-run: wipes and rebuilds mission/.

BASE="$(dirname "$0")/mission"

rm -rf "$BASE"
mkdir -p "$BASE/incoming" "$BASE/ok" "$BASE/errors"

cat > "$BASE/README.txt" <<'EOF'
Six sensor logs came in overnight under mission/incoming/. Each one
contains a status line -- either:

  STATUS: OK

or

  STATUS: ERROR

Sort them: OK logs go to mission/ok/, ERROR logs go to mission/errors/.
Same shape as day15 -- a for loop, a grep -q check inside an if, and mv
-- so this time write the whole script yourself. mission/process_sensors.sh
already exists and is executable, but it's empty. Open it in nano and
build it from nothing: shebang, DIR, the works.

One new piece this time: after sorting everything, also write a tally to
mission/summary.txt with exactly this format:

  OK: <number of ok files>
  ERROR: <number of error files>
  TOTAL: <total files>

To do that you need a counter that goes up by one each time through the
loop. The pattern:

  count=0
  count=$((count + 1))

`$((...))` does arithmetic in bash -- you've actually already seen this
exact syntax before, reading it in day10/day12's check scripts even if
you didn't write it yourself. Keep two counters (one for OK, one for
ERROR), increment the right one inside your if/else, and write both
(plus their sum) to summary.txt once the loop finishes.

Run it with:
  ./mission/process_sensors.sh

Then check your work with:
  ./mission/check_summary.sh
EOF

cat > "$BASE/incoming/sensor_a.txt" <<'EOF'
SENSOR: temp-01
STATUS: OK
EOF

cat > "$BASE/incoming/sensor_b.txt" <<'EOF'
SENSOR: temp-02
STATUS: OK
EOF

cat > "$BASE/incoming/sensor_c.txt" <<'EOF'
SENSOR: humidity-01
STATUS: ERROR
EOF

cat > "$BASE/incoming/sensor_d.txt" <<'EOF'
SENSOR: pressure-01
STATUS: OK
EOF

cat > "$BASE/incoming/sensor_e.txt" <<'EOF'
SENSOR: humidity-02
STATUS: ERROR
EOF

cat > "$BASE/incoming/sensor_f.txt" <<'EOF'
SENSOR: temp-03
STATUS: OK
EOF

touch "$BASE/process_sensors.sh"
chmod +x "$BASE/process_sensors.sh"

cat > "$BASE/check_summary.sh" <<'CSEOF'
#!/bin/bash
DIR="$(dirname "$0")"

EXPECTED_OK="sensor_a.txt sensor_b.txt sensor_d.txt sensor_f.txt"
EXPECTED_ERROR="sensor_c.txt sensor_e.txt"

FAIL=0

if [ -n "$(ls -A "$DIR/incoming" 2>/dev/null)" ]; then
  echo "[FAIL] incoming/ still has unsorted files."
  FAIL=1
fi

for f in $EXPECTED_OK; do
  if [ ! -f "$DIR/ok/$f" ]; then
    echo "[FAIL] $f should be in ok/ but isn't."
    FAIL=1
  fi
done

for f in $EXPECTED_ERROR; do
  if [ ! -f "$DIR/errors/$f" ]; then
    echo "[FAIL] $f should be in errors/ but isn't."
    FAIL=1
  fi
done

if [ ! -f "$DIR/summary.txt" ]; then
  echo "[FAIL] summary.txt doesn't exist yet."
  FAIL=1
else
  if ! grep -q "^OK: 4$" "$DIR/summary.txt"; then
    echo "[FAIL] summary.txt doesn't have a line reading exactly 'OK: 4'."
    FAIL=1
  fi
  if ! grep -q "^ERROR: 2$" "$DIR/summary.txt"; then
    echo "[FAIL] summary.txt doesn't have a line reading exactly 'ERROR: 2'."
    FAIL=1
  fi
  if ! grep -q "^TOTAL: 6$" "$DIR/summary.txt"; then
    echo "[FAIL] summary.txt doesn't have a line reading exactly 'TOTAL: 6'."
    FAIL=1
  fi
fi

if [ "$FAIL" -eq 1 ]; then
  exit 1
fi

echo "[OK] all sensor logs sorted and summary is correct."
echo "FLAG{sensor_logs_triaged}"
CSEOF
chmod +x "$BASE/check_summary.sh"

echo "Mission environment built at: $BASE"
echo "Read mission/README.txt, then build mission/process_sensors.sh from scratch."
