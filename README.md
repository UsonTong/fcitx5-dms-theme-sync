# fcitx5 DMS theme sync

Dynamic fcitx5 Classic UI theme generator for DankMaterialShell/DMS.

It keeps the fcitx5 candidate window visually aligned with the current DMS Material colors by reading:

- `~/.config/DankMaterialShell/firefox.css`

The script generates compact rounded dark fcitx5 themes using an A/B slot strategy:

- `~/.local/share/fcitx5/themes/dms-rounded-dark-a`
- `~/.local/share/fcitx5/themes/dms-rounded-dark-b`

On each DMS color change, it writes the inactive slot, switches `classicui.conf` to that slot, and reloads Classic UI without restarting the fcitx5 process.

## Requirements

- Fedora/Linux with fcitx5
- `fcitx5`, `fcitx5-rime` or another input method
- ImageMagick `magick`
- `gdbus`
- systemd user services

On Fedora:

```bash
sudo dnf install -y fcitx5 fcitx5-rime ImageMagick glib2
```

## Install / restore

From this repository:

```bash
./install.sh
```

This installs:

- `~/.local/bin/fcitx5-dms-theme-sync`
- `~/.config/systemd/user/fcitx5-dms-theme-sync.service`
- `~/.config/systemd/user/fcitx5-dms-theme-sync.path`

Then it enables the watcher and runs one sync immediately.

## Manual sync

```bash
~/.local/bin/fcitx5-dms-theme-sync
```

## Check status

```bash
systemctl --user status fcitx5-dms-theme-sync.path
systemctl --user status fcitx5-dms-theme-sync.service
```

## Disable

```bash
systemctl --user disable --now fcitx5-dms-theme-sync.path
```

## Notes

The A/B theme slot approach avoids `fcitx5 -r`, so theme updates should not interrupt input method availability.
