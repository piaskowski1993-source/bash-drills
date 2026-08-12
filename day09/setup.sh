#!/bin/bash
# Day 9 scenario setup — the beacon is dead (day 8), but hassan.ali doesn't
# rely on just one way back in. Somewhere in this filesystem he left himself
# a note, and somewhere else he left himself a backdoor. Sweep for both with
# `find`: hidden files (-name ".*"), and files with the setuid bit set
# (-perm -4000).
# Safe to re-run: wipes and rebuilds mission/.

BASE="$(dirname "$0")/mission"

rm -rf "$BASE"
mkdir -p "$BASE/home/user/documents" "$BASE/var/log" "$BASE/var/tmp/.cache" "$BASE/usr/local/bin"

cat > "$BASE/home/user/.bashrc" <<'EOF'
# ~/.bashrc
export PS1='\u@\h:\w\$ '
alias ll='ls -la'
EOF

cat > "$BASE/home/user/.profile" <<'EOF'
# ~/.profile
export PATH="$HOME/bin:$PATH"
EOF

cat > "$BASE/home/user/.todo" <<'EOF'
reminder to self: if the beacon gets killed again, fallback lives in
/usr/local/bin, disguised as a normal health-check script. suid'd it so
it keeps root even when nobody's watching. clean it up before anyone notices.
EOF

cat > "$BASE/home/user/notes.txt" <<'EOF'
Meeting notes 3/2: nothing important.
EOF

cat > "$BASE/home/user/documents/report.txt" <<'EOF'
Q1 report draft, see shared drive.
EOF

cat > "$BASE/home/user/documents/budget.csv" <<'EOF'
item,cost
coffee,4.50
EOF

cat > "$BASE/var/log/syslog.old" <<'EOF'
Jan 1 00:00:01 host systemd: started.
EOF

cat > "$BASE/var/log/auth.log" <<'EOF'
Jan 1 00:00:02 host sshd: session opened.
EOF

cat > "$BASE/var/log/cron.log" <<'EOF'
Jan 1 00:00:03 host CRON: job ran.
EOF

touch "$BASE/var/tmp/.cache/notes"

for f in rotate-logs.sh backup.sh cleanup-tmp.sh; do
  cat > "$BASE/usr/local/bin/$f" <<EOF
#!/bin/bash
echo "running $f..."
EOF
  chmod 755 "$BASE/usr/local/bin/$f"
done

cat > "$BASE/usr/local/bin/sys-health-check" <<'EOF'
#!/bin/bash
echo "FLAG{setuid_backdoor_found}"
EOF
chmod 4755 "$BASE/usr/local/bin/sys-health-check"

echo "Mission environment built at: $BASE"
echo "Hassan Ali's beacon is dead, but he doesn't rely on just one way back"
echo "in. Sweep the filesystem under mission/ for what else he left behind."
