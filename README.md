# BrickBoy MiSTer

BrickBoy MiSTer brings the DMG LCD panel and sealed-speaker model from [kathoc/brickboy-dmg-fpgacore](https://github.com/kathoc/brickboy-dmg-fpgacore) to the MiSTer FPGA platform. The core uses the current [MiSTer-devel/Gameboy_MiSTer](https://github.com/MiSTer-devel/Gameboy_MiSTer) framework and a dedicated `BRICKBOY` internal identifier, so its settings do not collide with the standard Game Boy core.

## Install

Download the newest dated RBF from [`releases/`](releases/) or the repository's GitHub Releases page and copy it to `/media/fat/_Console/`.

## Panel model

The renderer operates at 640x576, four output pixels per native DMG dot, at the original 59.7275 Hz cadence. It includes:

- BrickBoy colour correction and measured/nostalgia panel profiles;
- passive-matrix crosstalk and asymmetric LCD persistence;
- dot structure, drop shadow, reflector grain, vignette, and reflection gradient;
- configurable ink, off-element tint, reflector saturation, brightness, and warmth;
- dead electrode lines and optional per-electrode flicker;
- sealed-speaker and case-response simulation;
- optional four-way D-pad shaping.

Dead-line flicker is a MiSTer-only extension and defaults to Off. Vinegar syndrome is intentionally not included: the original BrickBoy implementation depends on a 2D fBm field and has not yet been published in the Pocket RTL, so an independently invented substitute would not be faithful.

## Compatibility

The BrickBoy renderer consumes the Game Boy's two-bit DMG LCD stream. GBC software is therefore displayed through the DMG panel model rather than the normal colour renderer. SGB borders and MiSTer's normal video filters are not currently composited into the BrickBoy output.

## Build

Quartus Prime Lite 17.0 is the validated toolchain:

```text
quartus_sh --flow compile Gameboy
```

The generated bitstream is `output_files/Gameboy.rbf`. Release builds are renamed to `BrickBoy_YYYYMMDD.rbf`.

The first public build was fitted and timed successfully and tested on a DE10-Nano over HDMI.

## Source and licensing

This repository is GPL-3.0-or-later as a combined work. Individual files retain their original copyright and license headers.

- BrickBoy panel/audio RTL: derived from `kathoc/brickboy-dmg-fpgacore` (GPL-3.0-or-later repository).
- MiSTer platform and Game Boy framework: derived from `MiSTer-devel/Gameboy_MiSTer`; its source files carry their applicable per-file license headers.
- Open bootstrap ROM sources retain their upstream notices in [`BootROMs/`](BootROMs/).

This is an independently maintained MiSTer port. It is not maintained or hardware-tested by the Pocket core author.
