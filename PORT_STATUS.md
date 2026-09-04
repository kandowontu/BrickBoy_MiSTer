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
- panel dimming, frontlight gradient, backlight edge bleed, and contrast fade,
  with four source-parameter samples and Original defaults
- seeded native-cell dust/blemish specks at the original thresholds and
  quarter-brightness response
- panel brightness, contrast, saturation, gamma, black lift, and contrast dial
- STN bleed, crosstalk amount, column noise, edge banding, and cold response
- selectable ghost gamma using exact forward and interpolated inverse curves
- dead vertical and horizontal electrode lines with selectable edge bias,
  stuck-dark ratio, and row ratio
- Vinegar Syndrome centre-superellipse and blob patterns
- sealed-speaker/case audio model

## Deliberately excluded or adapted

- Sheen and sheen hotspot remain off because both are deliberately zero in the
  original DMG profile.
- Module margin/mask trim is clipped in the default Fill presentation.
- Persistence is stored at native resolution to fit FPGA memory.
- Vinegar coverage corners retain the original 4-bit opacity lattice. Native
  cell corners are bilinearly reconstructed across the 4x output; geometry,
  depth curves, and seeded patterns are unchanged.
- Backlight edge smoothstep uses a 16-entry fixed-point lookup table sampled
  from the original formula.
- Dust decisions are baked from the original seed-7 hash into a packed 2-bit
  native-cell ROM for the .25, .50, and 1.0 menu samples.
- Dead lines are substituted before the grid so they remain electrode-shaped;
  their optional flicker control is a MiSTer extension. The menu severity
  levels are discrete hardware-useful samples of the continuous source value.
- Air-gap depth selects discrete diagonal caster taps and shadow blur selects
  discrete penumbra weights. This preserves the original default without the
  extra full-colour framebuffer required for arbitrary shader geometry.
- Ghost inverse-gamma tables use 512 samples with linear interpolation; the
  original menu choice remains visually and numerically aligned at the
  eight-bit input/output boundaries.
- MiSTer panel trim, ink, reflector-saturation, rumble, and physical-controller
  behavior are platform controls rather than original BrickBoy parameters.
