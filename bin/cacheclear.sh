#!/usr/bin/env bash

# Config
LOG_DIR="$HOME/.local/var/log"
LOG_FILE="$LOG_DIR/cache-clear-$(date +%F_%H-%M-%S).log"

# Append all ouputs to log file
exec > >(tee -a "$LOG_FILE") 2>&1

# Helpers
confirm() {
    read -r -p "${1:-Are you sure? [y/N]} " ans
    [[ "$ans" =~ ^([yY][eE][sS]|[yY])$ ]]
}

announce() { 
    printf "\n\e[1;34m==> %s\e[0m\n" "$1"; 
}

announce "Cache clear - $(date '+%x')" 

announce "~/.cache size: $(du -sh ~/.cache | cut -f1)"
if confirm "Clear ~/.cache? [y/N]"; then
    sudo rm -rf ~/.cache
fi

announce "uv cache size: $(du -sh $(uv cache dir) | cut -f1)"
if confirm "Clear $(uv cache dir)? [y/N]"; then
    rm -rf $(uv cache dir)
fi
