# Changelog

## Unreleased

- Restore Vinegar Syndrome from BrickBoy's original-software shader rather
  than the earlier invented approximation.
- Add both original rot patterns: centre superellipse and irregular blobs.
- Bake the original seeded four-octave fBm/coverage maps into a 96-bit-wide
  M10K ROM and bilinearly reconstruct the 4x output.
- Add a `BrickBoy Optics` menu page for original grid strength, drop-shadow
  opacity, LCD persistence, reflection gradient, corner vignette, and matte
  grain. Each control defaults to the exact profile value.

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
