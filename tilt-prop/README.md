# Tilt Prop

A stand that holds a sewing machine tipped back in its base. Stand it on
the table behind the base and tip the machine back onto it: its top
catches the machine's arm, or some other solid part, so the machine stays
put while you oil it or work on the mechanism underneath, with both hands
free. The machine's weight goes into the table through the prop, instead
of tipping the base up.

![Two tilt props: a cradle for a round arm, and a flat top sloped
20°](images/tilt-prop.png)

It was spun off from the [VSM Base](https://github.com/bobdrzyzgula/VSM-Base),
a 3D-printable base for vintage sewing machines, but works with any base
that lets the machine tip back. The same file is kept in that repository
too.

## Features

- **Cradle or flat top**: a cradle for a round arm, or a flat top for
  anything else. Either can slope, to meet a part that comes to rest at an
  angle.
- **A foot sized for stability**: a load on the top, pressing square to
  it, can lean a further 15° either way before the prop would tip. A
  sloping top gets a longer foot.
- **Two tapered legs**, front and back, with a gabled opening between them,
  so it prints upright without supports.
- **No libraries**: one self-contained OpenSCAD file.

At the default settings (a cradle for a Singer 99K tipped back to 90°) the
prop is 6" tall to the bottom of the cradle, 1.5" wide along the arm, on a
94 × 94 mm foot.

## Files

| File | Purpose |
|---|---|
| `tilt_prop.scad` | The parametric model (plain OpenSCAD, no libraries) |
| `stl/tilt_prop.stl` | Ready-to-print STL at the default settings (99K cradle) |
| `docs/USERS_GUIDE.md` | Measuring, settings, printing and use |
| `images/` | OpenSCAD render |
| `LICENSE` | MIT License |

## Quick start

1. Tip your machine back to where you want it and measure from the table
   to the part that will rest on the prop.
2. Set `height`, the top type and its size in the Customizer, and render.
3. Print standing on its foot, with no supports; 15% infill is plenty.
4. Line the top with felt or cork.

See the [User's Guide](docs/USERS_GUIDE.md) for measuring and the
settings.

## Status

The same design as the VSM Base's tilt prop. Printed in basic PLA at the
default settings (a 1" cradle, 6" high) and in use: it holds a Singer 99
tipped back, including one fitted with the chromed light, without much
deflection.

## Credits and license

Designed by Bob Drzyzgula. The OpenSCAD code, this README and the User's
Guide were written by Claude (Anthropic) at his direction.

Released under the [MIT License](LICENSE).
