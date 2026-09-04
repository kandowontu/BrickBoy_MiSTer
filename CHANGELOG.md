# Changelog

## 0.4.0 - 2026-09-04

- Restore Vinegar Syndrome from BrickBoy's original-software shader rather
  than the earlier invented approximation.
- Add both original rot patterns: centre superellipse and irregular blobs.
- Bake the original seeded four-octave fBm/coverage maps into four parity-banked
  M10K ROMs with direct eight-bit opacity at each unique node, then bilinearly
  reconstruct the 4x output without visible contour steps.
- Add a `BrickBoy Optics` menu page for original grid strength, drop-shadow
  opacity, LCD persistence, reflection gradient, corner vignette, and matte
  grain. Each control defaults to the exact profile value.
- Replace the quantized Vinegar coverage experiments with direct eight-bit
  opacity while using unique-node storage to reduce total block-memory use.
- Add a `BrickBoy Detail` page for dot fill, gap darkness, and persistence gate
  controls, all defaulting to the source profile values.
- Add a `BrickBoy Aging` page for the original panel dimming, frontlight
  gradient, backlight edge bleed, and contrast-fade stages. Each four-position
  control samples the source parameter and defaults to the original zero value.
- Add original seeded dust/blemish specks after Vinegar, using the native-cell
  hash thresholds and quarter-brightness response from `defects.slang`.
- Add `BrickBoy Colour` and `BrickBoy STN` pages for the remaining source panel
  tone, gamma, bleed, crosstalk, noise, banding, and temperature parameters.
- Add air-gap depth, shadow softness, and selectable ghost-gamma controls;
  retain exact forward gamma curves and interpolated 512-sample inverse curves.
- Add dead-line edge-bias, stuck-dark, and row-rate controls generated from the
  original deterministic salts and formulas. Correct the earlier row-mask
  shortcut so rows no longer inherit column salts or edge bias.
- Fit and time the complete eight-bit Vinegar candidate successfully in Quartus
  Prime Lite 17.0 at 28,748 ALMs, 447 RAM blocks, and 85 DSP blocks, with
  +0.197 ns setup and +0.250 ns hold slack.
- Connect the existing reflector-grain menu level to the grain generator and
  widen its gain path so the 2x, 3x, and 4x choices no longer wrap.

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
