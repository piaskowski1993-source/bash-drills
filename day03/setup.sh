#!/bin/bash
# Day 3 scenario setup — a noisy server's logs, sifted with grep/pipes/redirection.
# Safe to re-run: wipes and rebuilds just the mission/ folder.

BASE="$(dirname "$0")/mission"
rm -rf "$BASE"

mkdir -p "$BASE/logs"
mkdir -p "$BASE/reports"

cat > "$BASE/logs/access.log" <<'EOF'
203.0.113.10 - - [12/Jul/2026:03:11:02] "GET /health" 200
203.0.113.11 - - [12/Jul/2026:03:11:05] "GET /api/users" 200
203.0.113.12 - - [12/Jul/2026:03:12:40] "POST /login" 401
203.0.113.13 - - [12/Jul/2026:03:13:15] "GET /api/users/9" 200
203.0.113.14 - - [12/Jul/2026:03:14:02] "GET /static/logo.png" 200
203.0.113.15 - - [12/Jul/2026:03:15:59] "GET /api/orders" 500
203.0.113.16 - - [12/Jul/2026:03:16:23] "POST /login" 401
203.0.113.17 - - [12/Jul/2026:03:17:47] "GET /api/orders/5" 200
203.0.113.18 - - [12/Jul/2026:03:18:09] "GET /api/reports" 500
198.51.100.23 - - [12/Jul/2026:03:19:31] "GET /admin/backup?token=FLAG{pipes_and_filters}" 500
203.0.113.19 - - [12/Jul/2026:03:20:00] "GET /health" 200
203.0.113.20 - - [12/Jul/2026:03:21:12] "GET /api/users" 200
EOF

cat > "$BASE/logs/app.log" <<'EOF'
[INFO] server boot complete
[DEBUG] cache warmed in 120ms
[ERROR] failed to connect to db (attempt 1)
[INFO] retrying db connection
[ERROR] failed to connect to db (attempt 2)
[INFO] db connection established
[DEBUG] handling request /api/users
[ERROR] disk usage above 90%
[INFO] cleanup job started
[INFO] cleanup job finished
[DEBUG] handling request /api/orders
[INFO] scheduled backup started
EOF

echo "Mission environment built at: $BASE"
