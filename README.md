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

## Fractional scaling artifact policy

For Wayland fractional scaling such as 1.25x, this generator avoids image-backed selected-candidate highlights. The panel and menu keep transparent outer rounded corners, but candidate/menu highlights are rendered by fcitx5 as solid colors instead of stretched PNG assets.

This prevents compositor resampling from picking up transparent or panel-colored pixels at the highlighted candidate boundary. The dynamic color path is unchanged: colors still come from `~/.config/DankMaterialShell/firefox.css`, and the A/B theme slot reload strategy is preserved.

If artifacts are still visible at 1.25x, prefer these safe adjustments in order:

1. Keep selected-candidate highlights color-only rather than PNG-backed.
2. Reduce outer panel/menu corner radius a little, rather than removing roundness.
3. Increase panel/menu asset size and keep 9-slice margins away from antialiased corner edges.

## Notes

The A/B theme slot approach avoids `fcitx5 -r`, so theme updates should not interrupt input method availability.
