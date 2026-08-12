#!/bin/bash
# Day 13 scenario setup — pure navigation drill, requested after day12
# surfaced a gap in counting multi-level `..` jumps. No new commands:
# just cd, .., ~, pwd, ls, cat, cp, deliberately practiced in a maze
# with dead ends. Standalone/no hassan.ali.
# Safe to re-run: wipes and rebuilds mission/.

BASE="$(dirname "$0")/mission"

rm -rf "$BASE"
mkdir -p "$BASE/frontdesk"
mkdir -p "$BASE/warehouse/aisle-a/shelf-1"
mkdir -p "$BASE/warehouse/aisle-a/shelf-2"
mkdir -p "$BASE/warehouse/aisle-b/shelf-1"
mkdir -p "$BASE/warehouse/aisle-b/shelf-2/sub-bin"
mkdir -p "$BASE/warehouse/aisle-b/shelf-3"
mkdir -p "$BASE/warehouse/aisle-c/shelf-1"

cat > "$BASE/README.txt" <<'EOF'
Work order: a customer needs a spare part (SR-4400 gasket) pulled from
the warehouse and brought up to the front desk.

Start in mission/warehouse/ and explore. Every shelf either has a clue
telling you where to actually look, or the part itself. Read each
clue.txt with `cat` and follow it -- some of them send you back up
before sending you somewhere new, so you'll need to count your `..`'s
carefully rather than guess.

Once you find spare_part.txt, copy it into mission/frontdesk/ (cp works
fine from wherever you are -- you don't have to cd all the way back
first, though you can). Then run mission/frontdesk/check_delivery.sh to
confirm the pickup.
EOF

cat > "$BASE/warehouse/aisle-a/shelf-1/clue.txt" <<'EOF'
Wrong shelf. The warehouse map says spare parts are stored in aisle-b,
not aisle-a. Head back up two levels and try there.
EOF

cat > "$BASE/warehouse/aisle-a/shelf-2/clue.txt" <<'EOF'
Empty shelf, just packing peanuts. Try aisle-c instead.
EOF

cat > "$BASE/warehouse/aisle-b/shelf-1/clue.txt" <<'EOF'
Getting closer -- you're in the right aisle. But SR-4400 parts live on
shelf-3, not shelf-1. Go back up one level and over.
EOF

cat > "$BASE/warehouse/aisle-b/shelf-2/sub-bin/clue.txt" <<'EOF'
Dead end -- this bin only holds packaging material. Head back up two
levels (out of shelf-2 entirely) and try shelf-3 instead.
EOF

cat > "$BASE/warehouse/aisle-b/shelf-3/spare_part.txt" <<'EOF'
SR-4400 gasket. Requisition code: RQ-88213.
Bring this to the front desk to complete the pickup.
EOF

cat > "$BASE/warehouse/aisle-c/shelf-1/clue.txt" <<'EOF'
Nothing here but empty crates. Check aisle-b -- specifically shelf-3.
EOF

cat > "$BASE/frontdesk/check_delivery.sh" <<'CDEOF'
#!/bin/bash
DIR="$(dirname "$0")"

if [ ! -f "$DIR/spare_part.txt" ]; then
  echo "[FAIL] no spare_part.txt at the front desk yet -- go find it in the warehouse and cp it here."
  exit 1
fi

if grep -q "RQ-88213" "$DIR/spare_part.txt"; then
  echo "[OK] correct part delivered."
  echo "FLAG{warehouse_navigated}"
else
  echo "[FAIL] a file made it here, but it's not the right part (wrong requisition code)."
  exit 1
fi
CDEOF
chmod +x "$BASE/frontdesk/check_delivery.sh"

echo "Mission environment built at: $BASE"
echo "Read mission/README.txt, then start exploring mission/warehouse/."
