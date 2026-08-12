#!/bin/bash
# Day 1 scenario setup — builds a fake "server" filesystem to navigate.
# Safe to re-run: wipes and rebuilds just the mission/ folder.

BASE="$(dirname "$0")/mission"
rm -rf "$BASE"

mkdir -p "$BASE/var/log/app"
mkdir -p "$BASE/etc/config"
mkdir -p "$BASE/home/dev-team/alice/notes"
mkdir -p "$BASE/home/dev-team/bob"
mkdir -p "$BASE/home/dev-team/.archive"
mkdir -p "$BASE/tmp/build-cache"

echo "server started ok" > "$BASE/var/log/app/access.log"
echo "connection refused" > "$BASE/var/log/app/error.log"
echo "port=8080" > "$BASE/etc/config/app.conf"
echo "just a build artifact, nothing to see" > "$BASE/tmp/build-cache/output.o"
echo "meeting notes: nothing important" > "$BASE/home/dev-team/alice/notes/meeting.txt"
echo "TODO: fix the login bug" > "$BASE/home/dev-team/bob/todo.txt"
echo "FLAG{pwd_ls_cd_101}" > "$BASE/home/dev-team/.archive/.old_backup.flag"

echo "Mission environment built at: $BASE"
