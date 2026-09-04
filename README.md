# BrickBoy MiSTer

BrickBoy MiSTer brings the DMG LCD panel and sealed-speaker model from [kathoc/brickboy-dmg-fpgacore](https://github.com/kathoc/brickboy-dmg-fpgacore) to the MiSTer FPGA platform. The core uses the current [MiSTer-devel/Gameboy_MiSTer](https://github.com/MiSTer-devel/Gameboy_MiSTer) framework. Its MiSTer content identifier remains `GAMEBOY`, so ROMs, palettes, borders, boot ROMs, and saves use the existing `Gameboy` folder.

## Install

Download [`BrickBoy.rbf`](releases/BrickBoy.rbf) or the newest build from the
repository's GitHub Releases page and copy it to `/media/fat/_Console/`.

## Panel model

The renderer operates at 640x576, four output pixels per native DMG dot, at the original 59.7275 Hz cadence. It includes:

- BrickBoy colour correction and measured/nostalgia panel profiles;
- passive-matrix crosstalk and asymmetric LCD persistence;
- dot structure, drop shadow, reflector grain, vignette, and reflection gradient;
- configurable ink, off-element tint, reflector saturation, brightness, and warmth;
- dead electrode lines and optional per-electrode flicker;
- sealed-speaker and case-response simulation;
- optional four-way D-pad shaping.

Dead-line flicker is a MiSTer-only extension and defaults to Off. Vinegar Syndrome is derived from BrickBoy's published original-software shader specification: its centre superellipse and blob patterns, seed, four-octave 2D fBm, coverage curve, colour, and pass position are preserved. The continuous depth control is represented by three MiSTer menu samples.

The `BrickBoy Optics` page exposes original grid strength, drop-shadow
opacity, LCD persistence, reflection gradient, corner vignette, and matte
grain. Every setting defaults to `Original`, preserving the profile values.

The Vinegar coverage ROM keeps four bits per corner sample on the original
0–15 opacity lattice. This avoids the visible edge-level drift of the earlier
three-bit storage experiment while preserving the original geometry, seed,
patterns, and depth curves.

The `BrickBoy Detail` page adds source-stage controls for dot fill, gap
darkness, and the persistence luminance gate. Their `Original` choices retain
the reference renderer values.

The `BrickBoy Aging` page exposes the original panel dimming, frontlight
gradient, backlight edge bleed, contrast-fade, and dust stages. The
four-position controls sample the continuous source parameters at 0, 0.25,
0.5, and 1.0; `Original` is zero, as in the reference profile. The edge
smoothstep is a 16-entry fixed-point lookup approximation of the published
shader formula. Dust uses the original seed-7 hash, native 160x144 cell map,
thresholds, and quarter-brightness response.

The `BrickBoy Colour` and `BrickBoy STN` pages expose the remaining source
panel parameters: brightness, contrast, saturation, panel gamma, black lift,
contrast dial, STN bleed, crosstalk amount, column noise, edge banding, and
cold-temperature response. Each control provides four useful samples and
defaults to the reference profile value.

The `BrickBoy Optics II` page adds air-gap depth, shadow softness, and ghost
gamma. Air-gap depth and softness are discrete FPGA adaptations of the
source renderer's continuous caster geometry and blur; `Original` preserves
the reference appearance. Ghost gamma uses exact forward curves and a
512-sample linearly interpolated inverse curve for each menu choice.

The `BrickBoy Dead Lines` page exposes edge bias, stuck-dark ratio, and row
rate. Its deterministic column and row masks are generated from the original
BrickBoy salts and formulas; rows intentionally do not use edge bias, matching
the source renderer.

## Compatibility

The BrickBoy renderer consumes the Game Boy's two-bit DMG LCD stream. GBC software is therefore displayed through the DMG panel model rather than the normal colour renderer. SGB borders and MiSTer's normal video filters are not currently composited into the BrickBoy output.

## Build

Quartus Prime Lite 17.0 is the validated toolchain:

```text
quartus_sh --flow compile Gameboy
```

The generated bitstream is `output_files/Gameboy.rbf`. Release builds are renamed to `BrickBoy.rbf`; the build date is shown inside the MiSTer core menu.

The current candidate uses 28,906 ALMs, 543 of 553 RAM blocks, and 83 DSP
blocks. Quartus reports +0.518 ns worst-case setup slack and +0.246 ns
worst-case hold slack. The first public build was also tested on a DE10-Nano
over HDMI; this candidate still requires hardware testing.

## Source and licensing

This repository is GPL-3.0-or-later as a combined work. Individual files retain their original copyright and license headers.

- BrickBoy panel/audio RTL: derived from `kathoc/brickboy-dmg-fpgacore` (GPL-3.0-or-later repository).
- MiSTer platform and Game Boy framework: derived from `MiSTer-devel/Gameboy_MiSTer`; its source files carry their applicable per-file license headers.
- Open bootstrap ROM sources retain their upstream notices in [`BootROMs/`](BootROMs/).

This is an independently maintained MiSTer port. It is not maintained or hardware-tested by the Pocket core author.
