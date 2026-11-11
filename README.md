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
| [Bobbin Box](bobbin-box/) | A lidded box of stacking trays for 40 class 15/66 bobbins (or any round bobbin), lifted out together by a center knob; hinged or lift-out lid; optional images on any face. From the [VSM Base](https://github.com/bobdrzyzgula/VSM-Base). | Trays printed and used; the box itself not yet printed |
| [Tilt Prop](tilt-prop/) | A stand that holds a sewing machine tipped back in its base for oiling and servicing, with a cradle or flat top, level or sloped, on a foot sized to stay upright. From the [VSM Base](https://github.com/bobdrzyzgula/VSM-Base). | Printed in PLA and in use on a Singer 99 |
| [Point Turner](point-turner/) | A curved, blunt-pointed tool for pushing out the corners of a bag, pillow or collar after it's turned right side out. Small (3 in), medium (4½ in) and large (6 in), with the same tip and grips shaped for their size; right- or left-handed; optional creaser end and hanging hole. | Settled. Printed in PLA and PETG, every size, hand and butt end; no brim needed |
| [Pattern Weights](pattern-weights/) | Weights made from a stack of standard steel washers (USS, SAE or metric, ¾ to 4 in) in a printed cup with a felt-pad base and a screw-down lid that clamps any stack within the washers' thickness tolerance, plus a storage box with a hinged, snap-latched lid. Optional artwork on the lids and under the box; the console reports each weight's mass. | Checked in OpenSCAD; not yet printed |

## Using the models

The models are OpenSCAD files. Some use no libraries; the Needle Inserter,
the Bobbin Box and the Pattern Weights need [BOSL2](https://github.com/BelfrySCAD/BOSL2)
installed in OpenSCAD's libraries folder. Open one in
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
