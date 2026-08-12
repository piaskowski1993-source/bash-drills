#!/bin/bash
# Day 5 scenario setup — a permissions incident: a broken deploy script,
# an over-exposed credentials file, and a locked-down flag file.
# Safe to re-run: wipes and rebuilds just the mission/ folder.

BASE="$(dirname "$0")/mission"
rm -rf "$BASE"

mkdir -p "$BASE/incident"

cat > "$BASE/incident/deploy.sh" <<'EOF'
#!/bin/bash
echo "Deploy step complete: service restarted, health check OK."
EOF
chmod 644 "$BASE/incident/deploy.sh"

cat > "$BASE/incident/creds.txt" <<'EOF'
service_account=svc-deploy
api_key=REDACTED-DO-NOT-SHIP-THIS-WORLD-READABLE
EOF
chmod 666 "$BASE/incident/creds.txt"

cat > "$BASE/incident/flag.secret" <<'EOF'
FLAG{permission_bits_unlocked}
EOF
chmod 000 "$BASE/incident/flag.secret"

echo "Mission environment built at: $BASE"
