#!/bin/bash
# Day 2 scenario setup — messy "inbox" that needs cleaning up with cp/mv/rm/mkdir/touch.
# Safe to re-run: wipes and rebuilds just the mission/ folder.

BASE="$(dirname "$0")/mission"
rm -rf "$BASE"

mkdir -p "$BASE/inbox"
mkdir -p "$BASE/archive/2026-06"
mkdir -p "$BASE/home/dev-team"

echo "draft - superseded by v2" > "$BASE/inbox/weekly_report_v1.txt"
echo "FINAL REPORT: Q2 numbers look good." > "$BASE/inbox/weekly_report_v2.txt"
echo "FINAL REPORT: Q2 numbers look good." > "$BASE/inbox/weekly_report_v2_copy.txt"
echo -e "port=8080\nmode=prod" > "$BASE/inbox/server.conf"
echo "GET /health 200" > "$BASE/inbox/access.log"
echo "connection timeout at 03:12" > "$BASE/inbox/error.log"
echo "junk build artifact" > "$BASE/inbox/build.tmp"
echo "junk build artifact" > "$BASE/inbox/build2.tmp"
echo "FLAG{glob_skips_dotfiles}" > "$BASE/inbox/.audit_flag.txt"

echo "GET /health 200 (june)" > "$BASE/archive/2026-06/access.log.1"
echo "no errors in june" > "$BASE/archive/2026-06/error.log.1"

echo "Mission environment built at: $BASE"
