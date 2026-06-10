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

For Wayland fractional scaling such as 1.25x, this generator avoids transparent pixels on internal highlight assets. The panel and menu keep transparent outer rounded corners, but highlight/preedit assets are rendered on top of their matching panel/menu background color instead of `xc:none`.

This prevents compositor resampling from picking up transparent pixels between the highlighted candidate and the panel background. The dynamic color path is unchanged: colors still come from `~/.config/DankMaterialShell/firefox.css`, and the A/B theme slot reload strategy is preserved.

If artifacts are still visible at 1.25x, prefer these safe adjustments in order:

1. Reduce corner radius a little, rather than removing roundness.
2. Increase panel/menu asset size and keep 9-slice margins away from antialiased corner edges.
3. Avoid transparent or semi-transparent pixels on internal assets such as highlight and preedit.

## Notes

The A/B theme slot approach avoids `fcitx5 -r`, so theme updates should not interrupt input method availability.
