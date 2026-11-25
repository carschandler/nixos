# stt-visualizer

Quickshell layer-shell overlay: a pastel spectrum wave hugging the bottom edge
of the bottom-most display, shown only while Handy is recording. Packaged by
`package.nix`; wired up (package + user service) in `../stt.nix`, which the
hyprland module imports.

## How it works

- `bin/handy-watch` follows PipeWire (`pw-dump -m`) and prints `active`/`idle`
  when a capture stream matching "handy" opens/closes. No changes to Handy.
- `bin/wave-feed` runs `cava` on the default mic (fixed sensitivity, soft noise
  gate, repeated frames dropped) and prints one line of 48 band levels per frame.
  `cava` only runs while recording, so no mic stream is held open when idle.
- `shell.qml` draws the wave (sum of 7 raised-cosine bumps, soft limiter and
  compression, rainbow gradient, glow), plays the bounce on activation and
  decays to zero on exit.

## Tuning

Most knobs are `readonly property`s at the top of `shell.qml` (`uiScale`,
`gain`, `compression`, `bumps`, the `kick*` bounce settings, `rainbow*`, ...).
Environment overrides: `HANDY_WAVE_SCREEN`, `HANDY_WAVE_RAINBOW=0`,
`HANDY_WAVE_DRIFT=1`, `HANDY_WAVE_ALWAYS=1` (always visible, for debugging),
and for the feed `HANDY_WAVE_SENS`, `HANDY_WAVE_GATE`, `HANDY_WAVE_AUTOSENS`.

The package is immutable, so to iterate live without rebuilding:

```
systemctl --user stop stt-visualizer
STT_VISUALIZER_DIR=~/nixos/modules/desktop/_stt-visualizer stt-visualizer
# quickshell hot-reloads shell.qml on save; Ctrl-C, then start the service again
```

`nix run .#stt-visualizer` also works from the flake root.

## Gotchas learned the hard way

- `cava`'s autosens re-amplifies a quiet room to full scale on every start, so
  it stays off (`autosens = 0`, sensitivity calibrated for speech).
- Don't `kill 0` from the helper scripts: they share a process group with
  quickshell and would take it down. They `pkill -P $$` their own children.
- Quickshell can exit when its last window closes, so the surface stays mapped
  (transparent and click-through) while idle.
- The scripts' dependencies are listed in `package.nix`; anything a script
  shells out to (e.g. `sed`) must be there or it fails silently under the wrapper.
