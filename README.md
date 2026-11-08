# Sewing Notions

A collection of small 3D-printable projects for sewing: notions, gadgets
and helpers for the sewing room and the sewing-machine bench. Each project
is a parametric OpenSCAD model in its own folder, with its own README,
User's Guide, images and a ready-to-print STL, so it can be used (or
copied) on its own.

## Projects

| Project | What it is | Status |
|---|---|---|
| [Needle Bin I](needle-bin-i/) | A sealed, print-in-one-piece disposal bin for used and broken sewing needles: they drop in through a funnel and don't come back out. The original design. | Printed many times, round and faceted |
| [Needle Bin II](needle-bin-ii/) | Needle Bin I plus recessed artwork: up to two SVG images (logos, or text laid out as SVG) on the side, laid flat on a face or wrapped around a round bin, sized as a percentage of the face. | Wrapped artwork printed; flat-face placement checked in OpenSCAD |
| [Needle Inserter](needle-inserter/) | A tool for putting an HAx1 needle into the machine: a keyed pocket with a spring tab holds the needle by its shank, flat facing the right way, on an upright grip you pinch between thumb and forefinger. | Printed in PETG; tested with #9 to #21 needles |

## Using the models

The models are OpenSCAD files. Most use no libraries; the Needle Inserter
needs [BOSL2](https://github.com/BelfrySCAD/BOSL2) installed in OpenSCAD's
libraries folder. Open one in
[OpenSCAD](https://openscad.org/), adjust it in the Customizer
(Window › Customizer), render (F6) and export an STL or 3MF for your
slicer. Each project's `docs/USERS_GUIDE.md` explains its settings, how to
print it and how to use it. All dimensions are in millimeters.

## License

Every project in this repository is released under the
[MIT License](LICENSE). Each project folder carries its own copy of the
license, so a folder can be shared by itself.

## Credits

Projects are designed, printed and tested by Bob Drzyzgula, who maintains
this repository. Each project's README says who wrote its code. The READMEs
and User's Guides are written by Claude (Anthropic) at Bob's direction.
