#!/bin/bash
# Day 4 scenario setup — a login log with a brute-force pattern buried in it,
# for sort / uniq / uniq -c / awk practice (plus grep recap from day 3).
# Safe to re-run: wipes and rebuilds just the mission/ folder.

BASE="$(dirname "$0")/mission"
rm -rf "$BASE"

mkdir -p "$BASE/logs"

cat > "$BASE/logs/auth.log" <<'EOF'
203.0.113.10 - - [23/Jul/2026:08:01:00] "POST /login" 200
203.0.113.11 - - [23/Jul/2026:08:02:11] "POST /login" 200
203.0.113.12 - - [23/Jul/2026:08:03:45] "POST /login" 200
203.0.113.13 - - [23/Jul/2026:08:04:12] "POST /login" 200
203.0.113.14 - - [23/Jul/2026:08:05:33] "POST /login" 200
203.0.113.15 - - [23/Jul/2026:08:06:50] "POST /login" 200
198.51.100.77 - - [23/Jul/2026:08:07:02] "POST /login" 401
198.51.100.77 - - [23/Jul/2026:08:07:05] "POST /login" 401
198.51.100.77 - - [23/Jul/2026:08:07:09] "POST /login" 401
198.51.100.77 - - [23/Jul/2026:08:07:14] "POST /login" 401
198.51.100.77 - - [23/Jul/2026:08:07:20] "POST /login" 401
198.51.100.77 - - [23/Jul/2026:08:07:27] "POST /login" 401
198.51.100.77 - - [23/Jul/2026:08:07:35] "POST /login" 401
198.51.100.77 - - [23/Jul/2026:08:07:44] "POST /login" 401
198.51.100.77 - - [23/Jul/2026:08:07:54] "POST /login" 401
198.51.100.77 - - [23/Jul/2026:08:08:05] "POST /login" 401
198.51.100.77 - - [23/Jul/2026:08:08:17] "POST /login" 401
198.51.100.77 - - [23/Jul/2026:08:08:30] "POST /login" 401
198.51.100.77 - - [23/Jul/2026:08:08:44] "POST /login" 401
198.51.100.77 - - [23/Jul/2026:08:08:59] "POST /login" 401
198.51.100.77 - - [23/Jul/2026:08:20:59] "POST /login?note=FLAG{sort_uniq_awk_reveal_the_pattern}" 200
203.0.113.16 - - [23/Jul/2026:08:22:10] "POST /login" 200
203.0.113.17 - - [23/Jul/2026:08:23:40] "POST /login" 200
203.0.113.18 - - [23/Jul/2026:08:24:55] "POST /login" 200
203.0.113.19 - - [23/Jul/2026:08:25:12] "POST /login" 200
203.0.113.20 - - [23/Jul/2026:08:26:30] "POST /login" 200
EOF

echo "Mission environment built at: $BASE"
