#!/bin/bash
# Day 15 scenario setup — scripting track: `for` loops, second dedicated
# scripting day after day11's `if`/test. Combines already-known skills
# (grep from day03/04, if/test from day11, mv from day02/13) inside a
# loop the user writes themselves, same "review skills + one new piece
# of syntax" shape as day11. Standalone/no hassan.ali.
# Safe to re-run: wipes and rebuilds mission/.

BASE="$(dirname "$0")/mission"

rm -rf "$BASE"
mkdir -p "$BASE/incoming" "$BASE/processed" "$BASE/rejected"

cat > "$BASE/README.txt" <<'EOF'
Six report files landed in mission/incoming/ overnight and need to be
sorted before the morning batch job runs. Each valid report starts with
the exact header line:

  id,name,amount

Anything with that exact header goes to mission/processed/. Anything
without it -- wrong column order, missing entirely, typo'd -- goes to
mission/rejected/.

Doing this one file at a time with mv would work, but doesn't scale --
six files today could be six hundred tomorrow. This is exactly what
`for` loops are for: write the steps once, and let the shell repeat
them automatically for every file that matches.

The shape of a for loop:

  for file in some/path/*.ext; do
    ...
  done

Inside the loop, $file holds the path to whichever file the loop is
currently on. You already know how to check a file's first line
(grep, day03/04), test something's exit status (if, day11), and move a
file (mv, day02/day13) -- this is about combining those, once, inside a
loop.

Open mission/process_reports.sh in nano and fill in the TODO. Run it
with:

  ./mission/process_reports.sh

Then check your work with:

  ./mission/check_batch.sh
EOF

cat > "$BASE/incoming/report_alpha.csv" <<'EOF'
id,name,amount
1,Alice,120
2,Bob,75
EOF

cat > "$BASE/incoming/report_beta.csv" <<'EOF'
id,name,amount
3,Cara,200
EOF

cat > "$BASE/incoming/report_delta.csv" <<'EOF'
id,name,amount
4,Dan,50
5,Eve,300
EOF

cat > "$BASE/incoming/report_gamma.csv" <<'EOF'
name,id,amount
Frank,6,80
EOF

cat > "$BASE/incoming/report_epsilon.csv" <<'EOF'
7,Grace,60
8,Hank,90
EOF

cat > "$BASE/incoming/report_zeta.csv" <<'EOF'
id,fullname,amount
9,Ivy,110
EOF

cat > "$BASE/process_reports.sh" <<'PREOF'
#!/bin/bash
DIR="$(dirname "$0")"

# TODO: loop over every .csv file in "$DIR/incoming/", check whether its
# first line matches the required header exactly, and move it into
# "$DIR/processed/" if it does, or "$DIR/rejected/" if it doesn't.
#
# For-loop syntax reminder:
#   for file in some/path/*.ext; do
#     ...
#   done
#
# Required header (exact, case-sensitive): id,name,amount
PREOF
chmod +x "$BASE/process_reports.sh"

cat > "$BASE/check_batch.sh" <<'CBEOF'
#!/bin/bash
DIR="$(dirname "$0")"

EXPECTED_PROCESSED="report_alpha.csv report_beta.csv report_delta.csv"
EXPECTED_REJECTED="report_gamma.csv report_epsilon.csv report_zeta.csv"

FAIL=0

if [ -n "$(ls -A "$DIR/incoming" 2>/dev/null)" ]; then
  echo "[FAIL] incoming/ still has unprocessed files -- your loop should move everything out."
  FAIL=1
fi

for f in $EXPECTED_PROCESSED; do
  if [ ! -f "$DIR/processed/$f" ]; then
    echo "[FAIL] $f should be in processed/ but isn't."
    FAIL=1
  fi
done

for f in $EXPECTED_REJECTED; do
  if [ ! -f "$DIR/rejected/$f" ]; then
    echo "[FAIL] $f should be in rejected/ but isn't."
    FAIL=1
  fi
done

if [ "$FAIL" -eq 1 ]; then
  exit 1
fi

echo "[OK] all reports sorted correctly."
echo "FLAG{reports_batch_sorted}"
CBEOF
chmod +x "$BASE/check_batch.sh"

echo "Mission environment built at: $BASE"
echo "Read mission/README.txt, then fill in mission/process_reports.sh."
