#!/usr/bin/env bash

# Config
AUR=paru
LOG_DIR="$HOME/.local/var/log"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/system-maintenance-$(date +%F_%H-%M-%S).log"

PACCACHE_RETAIN=2   # keep N package versions
CACHE_DAYS=15       # prune ~/.cache entries older than N days
JOURNAL_RETAIN="7d" # e.g. 500M or 7d

# Append all ouputs to log file
exec > >(tee -a "$LOG_FILE") 2>&1

# Helpers
confirm() {
  read -r -p "${1:-Are you sure? [y/N]} " ans
  [[ "$ans" =~ ^([yY][eE][sS]|[yY])$ ]]
}

announce() { printf "\n\e[1;34m==> %s\e[0m\n" "$1"; }

announce "Arch Spring‑Clean starting $(date)" 

# Pacman cache trim
announce "Pacman cache trim (keeping latest $PACCACHE_RETAIN)"
current_cache=$(sudo du -sh /var/cache/pacman/pkg | cut -f1)
echo "Current cache: $current_cache"
if confirm "Clean pacman cache now? [y/N]"; then
  sudo paccache -vrk$PACCACHE_RETAIN
  sudo paccache -ruk0
fi
new_cache=$(sudo du -sh /var/cache/pacman/pkg | cut -f1)
echo "Cache after trim: $new_cache"

# Orphaned packages
announce "Removing orphaned packages"
mapfile -t ORPHANS < <($AUR -Qtdq)
if ((${#ORPHANS[@]})); then
  printf "Found %d orphan(s):\n%s\n" "${#ORPHANS[@]}" "${ORPHANS[*]}"
  if confirm "Remove these? [y/N]"; then
    sudo pacman -Rns "${ORPHANS[@]}"
  fi
else
  echo "No orphans detected."
fi

# $HOME/.cache prune
announce "Pruning ~/.cache (unused > $CACHE_DAYS days)"
deleted_files_and_dir=0
cache_before=$(du -sh ~/.cache | cut -f1)
echo "Before: $cache_before"
if confirm "Clean ~/.cache now? [y/N]"; then
    deleted_files_count="$(find ~/.cache -type f -mtime +$CACHE_DAYS -print -delete | wc -l)"
    deleted_dir_count="$(find ~/.cache -type d -empty -delete -print | wc -l)"
fi
cache_after=$(du -sh ~/.cache | cut -f1)
echo "Amount of deleted files: $deleted_files_count"
echo "Amoutn of deleted directories: $deleted_dir_count"
echo "After: $cache_after"

# Journald rotate & vacuum
announce "Vacuuming journald logs ($JOURNAL_RETAIN)"
journal_before=$(journalctl --disk-usage | awk '{print $NF}')
if confirm "Rotate & vacuum journald now? [y/N]"; then
  sudo journalctl --rotate
  sudo journalctl --vacuum-time=$JOURNAL_RETAIN
fi
journal_after=$(journalctl --disk-usage | awk '{print $NF}')
echo "Journald: $journal_before  ->  $journal_after"

# Failed systemd units
announce "Scanning for failed systemd services"
if systemctl --failed --quiet; then
  echo "No failed units detected."
else
  systemctl --failed --no-pager --plain
fi

announce "Spring‑Clean finished in ${SECONDS}s — log saved to $LOG_FILE"
