#!/bin/bash
# Day 11 scenario setup — a pre-deploy checklist, standalone/everyday (no
# hassan.ali). Rolls forward three already-covered skills (du from day10,
# chmod from day05, grep from day03/04) as the investigation, then uses
# them as the on-ramp into the first bit of real scripting: an `if [ ]`
# conditional. Two of three checks in preflight.sh are done as worked
# examples; the third is a TODO the user completes themselves.
# Safe to re-run: wipes and rebuilds mission/.

BASE="$(dirname "$0")/mission"

rm -rf "$BASE"
mkdir -p "$BASE/data"

cat > "$BASE/README.txt" <<'EOF'
Pre-deploy checklist for the app. Before we ship, get mission/preflight.sh
to a clean pass. Right now it's failing:

  1. data/ must be under a 50M storage quota
  2. deploy.sh must be executable
  3. config.env must have ENV set to production

Checks 1 and 2 are already wired up in preflight.sh as worked examples.
Check 3 is left as a TODO for you to fill in yourself using grep and an
if-statement — same idea as check 2, but testing a file's contents
instead of its permissions.

Investigate with the tools you already know (du, ls -l, grep), fix what's
broken, then complete the missing check and re-run preflight.sh.
EOF

# --- junk in data/, safe to delete ---
fallocate -l 40M "$BASE/data/old_debug.log"
fallocate -l 25M "$BASE/data/cache.tmp"

# --- keep: the app actually needs this one ---
fallocate -l 10M "$BASE/data/current_data.db"

# --- broken permissions: not executable yet ---
cat > "$BASE/deploy.sh" <<'EOF'
#!/bin/bash
echo "deploying build..."
EOF
chmod 644 "$BASE/deploy.sh"

# --- wrong config value ---
cat > "$BASE/config.env" <<'EOF'
ENV=staging
EOF

cat > "$BASE/preflight.sh" <<'PREEOF'
#!/bin/bash
DIR="$(dirname "$0")"

# Check 1: data/ must be under the 50M quota, and current_data.db must still exist
SIZE=$(du -sm "$DIR/data" | cut -f1)
if [ ! -f "$DIR/data/current_data.db" ]; then
  echo "[FAIL] data/current_data.db is missing -- don't delete files you need!"
  exit 1
elif [ "$SIZE" -le 50 ]; then
  echo "[OK] disk usage: ${SIZE}M"
else
  echo "[FAIL] disk usage: ${SIZE}M (limit 50M)"
  exit 1
fi

# Check 2: deploy.sh must be executable
if [ -x "$DIR/deploy.sh" ]; then
  echo "[OK] deploy.sh is executable"
else
  echo "[FAIL] deploy.sh is not executable"
  exit 1
fi

# Check 3: config.env must have ENV=production
# TODO -- replace the two lines below with a real check.
# Hint: grep -q "ENV=production" somefile   checks silently and just sets
# an exit status (0 = found, 1 = not found) that you can test with if.
echo "[FAIL] config check not implemented yet"
exit 1

echo "FLAG{preflight_passed}"
PREEOF
chmod +x "$BASE/preflight.sh"

echo "Mission environment built at: $BASE"
echo "Pre-deploy checklist under mission/ is failing. Read README.txt, then"
echo "get mission/preflight.sh to a clean pass."
