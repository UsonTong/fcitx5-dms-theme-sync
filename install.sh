#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

install -Dm755 "$repo_dir/bin/fcitx5-dms-theme-sync" "$HOME/.local/bin/fcitx5-dms-theme-sync"
install -Dm644 "$repo_dir/systemd/user/fcitx5-dms-theme-sync.service" "$HOME/.config/systemd/user/fcitx5-dms-theme-sync.service"
install -Dm644 "$repo_dir/systemd/user/fcitx5-dms-theme-sync.path" "$HOME/.config/systemd/user/fcitx5-dms-theme-sync.path"

systemctl --user daemon-reload
systemctl --user enable --now fcitx5-dms-theme-sync.path
"$HOME/.local/bin/fcitx5-dms-theme-sync"

printf 'Installed fcitx5 DMS theme sync. Watcher status: '
systemctl --user is-active fcitx5-dms-theme-sync.path
