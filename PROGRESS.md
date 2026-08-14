# bash-drills progress

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
| 14 | free -h, ps %MEM — runaway cache pre-warmer | `FLAG{memory_freed}` |

**14 / 14 solved.**

## Up next

Two tracks, interleaved rather than run back-to-back:
- **Scripting track:** `for` loops, `while` loops, `xargs`, functions (started day11 with `if`/test).
- **Hardware/everyday track:** `lsblk`/`mount`/`/etc/fstab` (drives), `lscpu`/`dmesg`/`lsusb`/`lspci` (started day10 with `du`, day12 with `df`, day14 with `free`).

## Unlockable rewards

Not installed yet — reminder-only:
- **`bat`** (nicer `cat`) — unlocks after day20
- **`eza`** (nicer `ls`) — unlocks after day30
