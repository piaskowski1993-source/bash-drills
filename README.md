# bash-drills

A daily practice log for learning bash, Linux sysadmin, and light security-investigation
skills — one self-contained scenario per day, each with a `setup.sh` that builds a
realistic `mission/` folder and a flag you earn by actually solving the problem
(no answer keys, no multiple choice).

Each `dayNN/` is independent. To try one:

```
cd dayNN
./setup.sh
cat mission/README.txt   # or similar — read the scenario
```

`mission/` folders are generated output (git-ignored) — safe to delete and rebuild
anytime by re-running `setup.sh`.

## Progress

| Day | Topic | Flag |
|-----|-------|------|
| 01 | filesystem navigation (pwd/ls/cd) | `FLAG{pwd_ls_cd_101}` |
| 02 | cp/mv/rm/mkdir/touch — messy inbox cleanup | `FLAG{glob_skips_dotfiles}` |
| 03 | grep/pipes/redirection — noisy server logs | `FLAG{pipes_and_filters}` |
| 04 | sort/uniq/uniq -c/awk — brute-force login log | `FLAG{sort_uniq_awk_reveal_the_pattern}` |
| 05 | permissions (chmod/chown) — broken deploy script | `FLAG{permission_bits_unlocked}` |
| 06 | ps/kill/top/jobs/bg/fg — hassan.ali's rogue process | `FLAG{graceful_shutdown_sigterm}` |
| 07 | cron persistence (pgrep -f, crontabs) | `FLAG{cron_persistence_defeated}` |
| 08 | network investigation (ss/lsof/nc) — the beacon | `FLAG{beacon_silenced}` |
| 09 | find (-name ".*", -perm -4000) — SUID backdoor sweep | `FLAG{setuid_backdoor_found}` |
| 10 | du -sh / --max-depth, ls -lahS — disk quota cleanup | `FLAG{quota_cleared}` |
| 11 | if/test/exit codes — pre-deploy checklist | `FLAG{preflight_passed}` |
| 12 | df -h vs du — shared volumes over quota | `FLAG{volumes_under_quota}` |
| 13 | cd/../~/mv navigation drill — warehouse maze | `FLAG{warehouse_navigated}` |

**13 / 13 solved.**

## Up next

Two tracks, interleaved rather than run back-to-back:
- **Scripting track:** `for` loops, `while` loops, `xargs`, functions (started day11 with `if`/test).
- **Hardware/everyday track:** `free -h` (memory), `lsblk`/`mount`/`/etc/fstab` (drives), `lscpu`/`dmesg`/`lsusb`/`lspci` (started day10 with `du`, day12 with `df`).
