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

For Wayland fractional scaling such as 1.25x, selected-candidate highlights use a seam-safe rounded PNG: a `64x32` capsule with 9-slice margins placed inside fully opaque pixels (`Left/Right=18`, `Top/Bottom=15`). The generator also draws an explicit solid center strip before drawing the capsule, so the stretched seams do not pass through antialiased transparent pixels.

This preserves rounded selected-candidate highlights while reducing compositor resampling artifacts at candidate boundaries. The dynamic color path is unchanged: colors still come from `~/.config/DankMaterialShell/firefox.css`, and the A/B theme slot reload strategy is preserved.

If artifacts are still visible at 1.25x, prefer these safe adjustments in order:

1. Increase highlight side margins further so 9-slice seams stay inside fully opaque pixels.
2. Reduce highlight corner radius a little, rather than removing roundness.
3. As a last resort, switch selected-candidate highlights back to color-only rendering.

## Notes

The A/B theme slot approach avoids `fcitx5 -r`, so theme updates should not interrupt input method availability.
