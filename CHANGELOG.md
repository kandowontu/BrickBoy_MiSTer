# Changelog

## 0.3.0 - 2026-09-02

- Reuse MiSTer's existing `Gameboy` content folder for ROMs, saves, palettes,
  borders, and boot ROMs.
- Use the simple release filename `BrickBoy.rbf`.
- Show the build date inside the core menu using MiSTer's standard build ID.
- Keep the repository structured for a future MiSTer-devel transfer; no
  MiSTer-devel pull request is included or submitted.

## v0.1.0 - 2026-08-30

- Initial MiSTer release of BrickBoy DMG.
- Added MiSTer menu, controller, audio, video, ROM, and save integration.
- Added BrickBoy display presets and LCD-style display controls.
- Added a distinct `BRICKBOY` core identifier so settings do not collide with
  the standard Game Boy core.
- Included open bootstrap ROM options; an original DMG boot ROM may also be
  loaded by the user.
- Omitted Vinegar Syndrome pending a faithful port of BrickBoy's original 2D
  fBm implementation. No substitute effect is included.
