# BrickBoy feature parity

This file distinguishes original BrickBoy behavior from MiSTer-specific
extensions and records remaining work. The reference is Kathoc's public
`brickboy-dmg-shader`, whose shaders and display-pipeline document are derived
from the original BrickBoy software renderer.

## Implemented original behavior

- DMG nostalgia and measured colour profiles
- bidirectional passive-matrix crosstalk
- asymmetric LCD persistence
- dot grid and two-layer drop shadow
- three-band reflector grain
- final non-uniformity, matte grain, and vignette
- menu controls for grid strength, drop-shadow opacity, persistence strength,
  final gradient, matte grain, and vignette (all default to Original)
- menu controls for dot fill, gap darkness, and ghost gate (all default to
  Original)
- dead vertical and horizontal electrode lines (hardware-adapted placement)
- Vinegar Syndrome centre-superellipse and blob patterns
- sealed-speaker/case audio model

## Original controls not exposed yet

- shadow geometry/blur
- ghost gamma and gate
- panel brightness, contrast, saturation, gamma, black lift, contrast dial,
  STN bleed, crosstalk amount/noise/banding, and cold-temperature response
- panel dimming, frontlight gradient, backlight bleed, contrast fade, and dust
- dead-line edge bias, stuck-dark ratio, and row ratio

These effects are present at their BrickBoy profile defaults where noted in
the RTL; the missing item is menu adjustability, not necessarily the effect.

## Deliberately excluded or adapted

- Sheen and sheen hotspot remain off because both are deliberately zero in the
  original DMG profile.
- Module margin/mask trim is clipped in the default Fill presentation.
- Persistence is stored at native resolution to fit FPGA memory.
- Vinegar coverage corners are stored at 3-bit precision and expanded onto the
  original opacity lattice to save 72 M10Ks; geometry and seeded patterns are
  unchanged.
- Dead lines are substituted before the grid so they remain electrode-shaped;
  their optional flicker control is a MiSTer extension.
- MiSTer panel trim, ink, reflector-saturation, rumble, and physical-controller
  behavior are platform controls rather than original BrickBoy parameters.
