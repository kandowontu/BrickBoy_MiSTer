"""Bake BrickBoy's original Vinegar opacity into a MiSTer ROM.

The equations and constants are a direct evaluation of FRAG_DEFECTS from
kathoc/brickboy-dmg-shader.  Three MiSTer menu depths are sampled (0.25, 0.50,
1.00), for both original rot modes.  Each native cell stores its four 4-bit
corner opacities; RTL bilinearly expands them across the 4x4 output cell.
"""
import math
from pathlib import Path

W, H = 160, 144
DEPTHS = (0.25, 0.50, 1.00)
SEED = 7.0


def fract(x): return x - math.floor(x)
def mix(a, b, t): return a + (b - a) * t
def clamp(x, a, b): return min(max(x, a), b)
def smoothstep(a, b, x):
    t = clamp((x - a) / (b - a), 0.0, 1.0)
    return t * t * (3.0 - 2.0 * t)


def hsh(x, y):
    return fract(math.sin(x * 127.1 + y * 311.7) * 43758.5453)


def vnoise(x, y):
    ix, iy = math.floor(x), math.floor(y)
    fx, fy = fract(x), fract(y)
    fx, fy = fx * fx * (3.0 - 2.0 * fx), fy * fy * (3.0 - 2.0 * fy)
    a, b = hsh(ix, iy), hsh(ix + 1, iy)
    c, d = hsh(ix, iy + 1), hsh(ix + 1, iy + 1)
    return mix(mix(a, b, fx), mix(c, d, fx), fy)


def fbm(x, y):
    value, amp = 0.0, 0.5
    for _ in range(4):
        value += amp * vnoise(x, y)
        x, y, amp = x * 2.0, y * 2.0, amp * 0.5
    return value


def opacity(px, py, depth, mode):
    # Original module UV: four native-dot margins around the 160x144 active LCD.
    ux, uy = (px + 4.0) / 168.0, 1.0 - (py + 4.0) / 152.0
    cover = 0.0
    if mode == 1:
        dx, dy = abs(ux - 0.5) * 2.0, abs(uy - 0.5) * 2.0
        dist = (dx ** 2.6 + dy ** 2.6) ** (1.0 / 2.6) * 0.5
        wob = 0.045 * (fbm((ux - 0.5) * 5.0 + SEED,
                           (uy - 0.5) * 5.0 + SEED) - 0.5)
        front = depth * 0.66
        cover = 1.0 - smoothstep(front - 0.16 + wob, front + wob, dist)
        cover *= mix(1.0, 0.5, clamp(dist / max(front, 1e-3), 0.0, 1.0))
    else:
        for i in range(4):
            sx = hsh(SEED + i * 3.1, 7.0)
            sy = hsh(SEED + i * 5.7, 13.0)
            cx, cy = 0.5 + (sx - 0.5) * 0.7, 0.5 + (sy - 0.5) * 0.7
            thresh = 0.08 + i * 0.22
            grow = smoothstep(thresh, min(thresh + 0.5, 1.0), depth)
            if grow <= 0.0: continue
            dx, dy = (ux - cx) * (160.0 / 144.0), uy - cy
            ang = math.atan2(dy, dx)
            ragged = 0.45 + 0.55 * fbm(ang * 1.7 + sx * 9.0,
                                       ang * 0.6 + sy * 9.0)
            rad = (0.09 + 0.30 * grow) * ragged
            cover = max(cover, 1.0 - smoothstep(rad * 0.55, rad,
                                                math.hypot(dx, dy)))
    op = cover * (0.45 + 0.5 * cover) * clamp(depth * 1.3, 0.0, 0.94)
    return int(round(clamp(op, 0.0, 0.94) * 15.0 / 0.94))


def main():
    maps = []
    # Address order matches RTL: Centre depths first, then Blob depths.
    for mode in (1, 0):
        for depth in DEPTHS:
            nodes = [[opacity(x, y, depth, mode) for x in range(W + 1)]
                     for y in range(H + 1)]
            for y in range(H):
                for x in range(W):
                    maps.append(nodes[y][x] | (nodes[y][x + 1] << 4) |
                                (nodes[y + 1][x] << 8) |
                                (nodes[y + 1][x + 1] << 12))
    out = Path(__file__).parents[1] / "rtl" / "brickboy" / "brick_vinegar_map.hex"
    with out.open("w", newline="\n") as f:
        # Keep map selection in the WORD rather than the DEPTH.  A 23040x96
        # ROM maps directly into parallel M10Ks; a 138240x16 ROM requires a
        # very large bank decoder on Cyclone V even though the bit count is
        # identical.
        for cell in range(W * H):
            word = sum(maps[m * W * H + cell] << (16 * m) for m in range(6))
            f.write(f"{word:024x}\n")
    print(f"wrote {W * H} 96-bit words to {out}")


if __name__ == "__main__":
    main()
