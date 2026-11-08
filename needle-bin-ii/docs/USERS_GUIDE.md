# Needle Bin II — User's Guide

Version 0.11

Needle Bin II was designed, printed and tested by Bob Drzyzgula, from his
Needle Bin I. Its artwork features, and this guide, were written by Claude
(Anthropic) at his direction.

## Contents

1. [What it is](#1-what-it-is)
2. [Quick start with the examples](#2-quick-start-with-the-examples)
3. [Preparing artwork](#3-preparing-artwork)
4. [Placing artwork](#4-placing-artwork)
5. [Sizing artwork](#5-sizing-artwork)
6. [Flat faces and wrapped artwork](#6-flat-faces-and-wrapped-artwork)
7. [Detail, depth and what will print](#7-detail-depth-and-what-will-print)
8. [Printing](#8-printing)
9. [Settings reference](#9-settings-reference)
10. [Console messages](#10-console-messages)
11. [Troubleshooting](#11-troubleshooting)
12. [Version history](#12-version-history)
13. [Credits and license](#13-credits-and-license)

## 1. What it is

Needle Bin II is a sealed disposal bin for used and broken sewing needles,
with up to two pieces of artwork recessed into its sides. The artwork comes
from SVG files: a shop's logo, a name, or any text you lay out in a drawing
program and save as SVG.

The bin itself is Needle Bin I, unchanged. Needles drop through a funnel
and a 3.2 mm hole into a slot in a split center post, fall over into the
closed chamber around it, and stay there; when it is full, the whole bin
is thrown away. The [Needle Bin I User's Guide](../../needle-bin-i/docs/USERS_GUIDE.md)
explains how the bin works and how to choose its size, needle length, hole
size and shape; all of that applies here. The bin's settings are listed
again in [section 9](#9-settings-reference).

With no artwork files set, Needle Bin II makes exactly the same solid as
Needle Bin I.

It's meant for sewing needles and pins, not for medical sharps.

## 2. Quick start with the examples

The model comes with two pieces of example artwork in `examples/` and two
Customizer presets that use them:

| Preset | What it makes |
|---|---|
| Example: pentagon, flat artwork | A five-sided bin with NEEDLES running up the front face (70% of the side's height) and the needle-and-thread drawing on a back face (85% of the face's width). |
| Example: round, wrapped artwork | A round bin, 25 mm in radius, with the drawing wrapped around the front and NEEDLES wrapped around the back. |

1. Open `needle_bin_ii.scad` in OpenSCAD. Keep `needle_bin_ii.json` in the
   same folder: it holds the presets.
2. Open the Customizer (Window › Customizer) and pick a preset from the menu
   at its top.
3. Render (F6). The pentagon takes a couple of seconds; the round one about
   half a minute.
4. Export (File › Export) and print upright with no supports.

`stl/needle_bin_ii_example_pentagon.stl` is the pentagon example, ready to
print.

To use your own artwork, put your SVG file in the same folder as
`needle_bin_ii.scad` (or a folder under it, as the examples are) and type
its name into `logo1_file`, such as `my_logo.svg` or `art/my_logo.svg`.
The settings are called "logo", but a slot takes any artwork, including
text.

## 3. Preparing artwork

OpenSCAD reads an SVG file's shapes and cuts every filled shape into the
bin. It doesn't read everything an SVG can hold, so check these before you
start.

**Filled shapes only.** Everything that should be cut must be a closed,
filled shape.

- **Text must be converted to outlines.** OpenSCAD ignores SVG text. In
  Illustrator, select the text and use Type › Create Outlines; in Inkscape,
  Path › Object to Path.
- **Lines drawn with a stroke should be turned into filled shapes**, so
  they are cut at exactly the width you see. In Illustrator use
  Object › Path › Outline Stroke; in Inkscape, Path › Stroke to Path.
- **Holes must be real holes.** The middle of an O, or a shape cut out of
  another, must be a hole in a compound path. A white shape laid on top of
  a black one is still a filled shape, and both will be cut.

**No pictures inside the SVG.** An SVG can carry an embedded bitmap image.
Saving a scanned or downloaded logo (a .png or .jpg) "as SVG" in
Illustrator usually just wraps the bitmap, and OpenSCAD finds nothing to
cut. Trace it into shapes first: in Illustrator, Image Trace, then Expand;
in Inkscape, Path › Trace Bitmap. For a small or blurry logo, trace a
copy enlarged several times, and clean up the result before using it.

**The page must fit the artwork.** OpenSCAD centers an SVG by its page
(its document box), not by the artwork on it. If the page is bigger than
the artwork, or the artwork isn't in the middle of it, it will be
off-center on the bin, and on a flat face it may be trimmed at the face's
edge. Fit the page to the artwork before saving: in Illustrator,
Object › Artboards › Fit to Artwork Bounds; in Inkscape,
Edit › Resize Page to Selection. A small, even margin all round is fine.

In OpenSCAD 2021.01 the page also has to start at 0,0. Some programs,
including OpenSCAD's own SVG export, write a page that starts elsewhere
(the `viewBox` in the file starts with negative numbers), and the artwork
is shifted by that amount. Opening such a file in Illustrator or Inkscape
and saving it again normally fixes it. The example files were written by
OpenSCAD and then adjusted to start at 0,0.

**Color, units and size don't matter.** Every filled shape is cut, whatever
its color, and the artwork is resized to the size you ask for.

**Leave out what's too fine to print.** See
[section 7](#7-detail-depth-and-what-will-print). A simplified, bolder
version of a logo usually looks better in plastic than a faithful copy of
a detailed one.

## 4. Placing artwork

Each slot (`logo1_…` and `logo2_…`) is placed by three settings:

**Angle around the bin** (`logo1_angle`). 0 is the front of the bin (the
side you see in OpenSCAD's Front view, View › Front), 180 the back. The
angle counts counterclockwise seen from above, so 90 is the right-hand
side as you look at the front and 270 the left. Logo 1 defaults to 0 and
logo 2 to 180.

On a flat-faced bin the artwork snaps to the face nearest the angle you
give (see [section 6](#6-flat-faces-and-wrapped-artwork)), so it is always
square to a face, but that face may be turned a little from the angle:

| Faces | Face nearest the front (0) and back (180) |
|---|---|
| 5 | turned 18° |
| 6 | square to the front and back |
| 7 | turned about 13° |
| 8 | turned 22.5° (a corner points to the front and back; the artwork goes on one of the two faces beside it) |

To put artwork on a particular face, give an angle close to it. On a
five-sided bin the faces are at 54, 126, 198, 270 and 342 degrees; on a
six-sided bin at 0, 60, 120, 180, 240 and 300.

**Height** (`logo1_center`, `logo1_z`). With `logo1_center` on (the
default), the artwork is centered halfway up the side of the bin. Turn it
off to set the height of the artwork's center yourself, in millimeters
above the bottom of the bin, with `logo1_z`.

**Rotation** (`logo1_rotate`). 0 leaves the artwork as drawn. 90 turns it
so it reads from the bottom of the bin to the top; -90 from top to bottom.
Any angle works. Rotation is applied before sizing, so sizes always mean
the same direction on the bin (see below).

## 5. Sizing artwork

Artwork always keeps its proportions unless you give both a width and a
height in millimeters.

**Percent mode** (`logo1_size_mode` = percent, the default). The artwork is
scaled to a percentage (`logo1_percent`, 5 to 100) of the face's width or
height, chosen by `logo1_fit_to`.

- **Width** is measured around the bin and **height** up the bin, after
  rotation. So for text turned to run up a tall face, choose `height` and,
  say, 80%: the text then runs 80% of the way up the side.
- **The face's width** is one flat face on a flat-faced bin. On a round
  bin it is the length of arc set by `round_face_angle` (120° by default,
  a third of the way round).
- **The face's height** is the whole height of the bin's side.

The console reports both at every render with artwork (see
[section 10](#10-console-messages)). For example:

| Bin | Face width | Face height |
|---|---|---|
| 5 faces, `outer_radius` 20 | 23.5 mm | 76.1 mm |
| 6 faces, `outer_radius` 20 | 20.0 mm | 76.1 mm |
| Round, `outer_radius` 20 | 41.9 mm (120°) | 76.1 mm |
| Round, `outer_radius` 25 | 52.4 mm (120°) | 80.3 mm |

Choosing width sets the width, and the height follows from the artwork's
proportions (or the other way round). The model can't see the artwork's
proportions in advance, so check the result: wide artwork fitted by
height may run off the sides of a face, and tall artwork fitted by width
may run off the top or bottom of the bin. On a flat face anything wider
than the face is trimmed at its edges.

**Millimeter mode** (`logo1_size_mode` = mm). `logo1_width` and
`logo1_height` give the size on the bin, in millimeters, measured the same
way as above (width around the bin, height up it, after rotation). Set one
of them to 0 to keep the artwork's proportions. Giving both stretches the
artwork to fit.

## 6. Flat faces and wrapped artwork

How artwork is cut depends on the number of faces (`shell_facets`):

**Flat faces, up to `flat_face_limit` (8).** Each piece of artwork is laid
flat on one face, square to it, so its depth is even. The artwork snaps to
the face nearest its angle and is trimmed half a millimeter in from each
edge of the face, so the cut never turns a corner onto the next face.
Rendering takes a second or two.

**Wrapped, above the limit.** The artwork is bent around the bin like a
label: it's cut into thin vertical strips (`wrap_strip`, 0.4 mm), and each
strip is set into the wall at its own angle. The depth stays even across
the whole piece instead of fading out toward its edges, as it would if a
flat cut were pushed into a curved wall. Wrapping takes longer to render:
about half a minute for the simple examples, several minutes for a
detailed logo.

**Between the two.** With 9 to about 30 faces (on a bin of the default
size), the shell has visible flat faces, but artwork is wrapped across
several of them, and the corners stand more than 0.1 mm proud of the curve
it's wrapped on. The artwork is wrapped at the faces' middles, so it's never
shallower than the depth you set, but it's deeper toward the corners. The
console warns about this. For artwork, use 8 or fewer faces, or enough
faces (about 32 or more at the default size) that the bin is effectively
round.

**Wide wrapped artwork.** Wrapping covers `wrap_span` millimeters of the
bin's circumference, centered on the artwork's angle. Left at 0, that's
half way round the bin, or the face width if `round_face_angle` is set
wider than that. Anything beyond it isn't cut. Set `wrap_span` larger for
artwork that goes more than half way round.

**Faster drafts.** While trying sizes on a round bin, set `wrap_strip` to
1.0 or so. The artwork will look stepped, but renders much faster. Set it
back to 0.4 for the final export.

## 7. Detail, depth and what will print

The artwork is a recess, so what you see is the shadow at its edges and
its floor. What prints depends mostly on the nozzle. With a 0.4 mm nozzle:

- **Recessed lines** (the strokes of the artwork) need to be about 0.5 mm
  wide or more on the bin. Lines much under 0.4 mm tend to break up or
  disappear.
- **Raised gaps** (plastic left standing between recessed areas, such as
  the space inside a letter or between feathers in a drawing) need to be
  about 0.5 mm wide too. Narrower gaps don't print, and the areas either
  side merge into one.

To check a piece of artwork, scale its finest line by the size it will be
on the bin. A line 1% of the artwork's width is 0.4 mm on artwork 40 mm
wide. If it's too fine, make the artwork bigger, use a larger bin, or
thicken the artwork. A round bin with a 25 mm radius has room for
artwork about 45 mm across, which keeps a fairly detailed logo printable.

**Depth** (`logo1_depth`, default 0.8 mm). Deeper recesses throw more
shadow and read better from a distance; shallower ones keep fine details
sharper. The depth must be less than the wall's thickness, measured across
a face; on a five-sided bin with the default 2.5 mm wall that is about
2.0 mm. The model stops with an error if it isn't.

## 8. Printing

Print as for Needle Bin I: upright, floor on the bed, with no supports.
Some points that matter for artwork:

- **Filament.** Matte PLA gives the best-reading artwork, in Bob's prints:
  the recess's edges throw clear shadows. Silk PLA's sheen washes the
  artwork out, even when the detail is all there. Basic PLA falls between.
- **Layer height.** Thinner layers give the artwork's edges better
  definition, because on an upright bin its outlines are built up layer by
  layer. You only need them where the artwork is: in Bambu Studio, Orca
  Slicer and PrusaSlicer you can set a smaller layer height for just that
  band of the bin (a height range modifier or the variable layer height
  tool) and print the rest at your usual height. With the artwork centered
  on a bin, the band is centered on half the bin's height.
- **Print time.** Thin layers and matte filaments, which usually print
  more slowly, make a bin with artwork take noticeably longer than a plain
  one.
- **Seams.** On a flat-faced bin, keep the seam out of the artwork, for
  example in a corner (seam position "Aligned" or "Back" in Bambu Studio
  and Orca Slicer).

## 9. Settings reference

All sizes are in millimeters and angles in degrees.

### The bin

These are the same as Needle Bin I's; see its guide for more on choosing
them.

| Setting | Default | What it does |
|---|---|---|
| `hole_radius` | 1.6 | Radius of the hole at the bottom of the funnel; also sets the slot's width and the post's size. |
| `max_needle_length` | 55 | Longest needle the bin must take; sets the slot's height and the bin's height. |
| `outer_radius` | 20 | Outside radius, to the corners on a flat-faced bin. |
| `shell_facets` | 300 | Number of sides of the shell and funnel. 8 or fewer: artwork lies flat on a face. |
| `round_facets` | 60 | Smoothness of the hole, post and cross-bore. |
| `wall_thickness` | 2.5 | Wall, floor and funnel thickness. |
| `funnel_angle` | 40 | Funnel slope from horizontal (more than 0, less than 90). |
| `overlap` | 0.5 | Overlap between merged parts. Leave it alone. |
| `generate_shell`, `generate_post`, `generate_funnel` | 1 | Parts switches (1 on, 0 off). Print with all three on. |
| `generate_pedistal` | 0 | A stand, for a demonstration model without the shell. |
| `pedistal_sides`, `pedistal_radius`, `pedistal_thickness` | 5, 1.5 × `outer_radius`, `wall_thickness` | The stand's shape and size. |

### Logo 1 and Logo 2

The two slots have the same settings, named `logo1_…` and `logo2_…`.

| Setting | Default | What it does |
|---|---|---|
| `logo1_file` | (empty) | The SVG file, relative to the `.scad` file's folder. Empty for no artwork. |
| `logo1_size_mode` | percent | `percent` or `mm`. |
| `logo1_percent` | 80 | Percent mode: size as a percentage of the face's width or height (5 to 100). |
| `logo1_fit_to` | width | Percent mode: `width` (around the bin) or `height` (up the bin), after rotation. |
| `logo1_width` | 25 | mm mode: width on the bin. 0 keeps proportions. |
| `logo1_height` | 0 | mm mode: height on the bin. 0 keeps proportions. |
| `logo1_center` | true | Center the artwork halfway up the side (ignores `logo1_z`). |
| `logo1_z` | 35 | Height of the artwork's center above the bottom, when `logo1_center` is off. |
| `logo1_angle` | 0 (logo 2: 180) | Position around the bin; 0 is the front, counterclockwise seen from above. Snaps to the nearest face on a flat-faced bin. |
| `logo1_rotate` | 0 | Rotation of the artwork: 90 reads bottom to top, -90 top to bottom. |
| `logo1_depth` | 0.8 | Depth of the recess; less than the wall's thickness. |

### Face placement and wrapping

| Setting | Default | What it does |
|---|---|---|
| `flat_face_limit` | 8 | Bins with this many faces or fewer get flat artwork; more, wrapped. |
| `round_face_angle` | 120 | Wrapped bins: how much of the circumference counts as one face for percent sizing (30 to 300). |
| `wrap_strip` | 0.4 | Width of the strips wrapped artwork is cut into. Smaller is smoother and slower. |
| `wrap_span` | 0 | Width, around the bin, that wrapping covers. 0: half way round, or the face width if wider. |

## 10. Console messages

With artwork set, every render prints a line describing the faces, such
as:

    ECHO: "Flat faces: a face is 23.5114 mm wide (5 faces) and 76.1394 mm tall; anything wider than the face is trimmed at its edges."
    ECHO: "Wrapped: a face is 52.357 mm wide (120 degrees of arc) and 80.3349 mm tall."

Warnings:

- **"logo N is … mm tall centered at z = … and runs past the end of the … mm shell."**
  Artwork sized by height (or given a height in mm) would run off the top
  or bottom of the bin. Make it smaller or move it.
- **"with N facets a wrapped label will cross the face edges and its depth will vary by up to … mm."**
  The bin has too many faces for flat artwork and too few to be round; see
  [section 6](#6-flat-faces-and-wrapped-artwork).

Errors, which stop the render:

- **"logoN_depth must be less than the wall thickness measured across a face"**:
  reduce the depth or thicken the wall.

## 11. Troubleshooting

**Nothing is cut, or parts of the artwork are missing.** The SVG probably
holds text, stroked lines or an embedded picture instead of filled shapes;
see [section 3](#3-preparing-artwork). Check the file name, too: it is
relative to the folder holding `needle_bin_ii.scad`, and OpenSCAD's
console reports a file it can't find.

**The artwork is off-center, or cut off at one edge of a face.** The SVG's
page is bigger than the artwork, or doesn't start at 0,0; see
[section 3](#3-preparing-artwork). Fit the page to the artwork and save it
again.

**The artwork is solid where it should have holes**, such as filled-in
letters. Holes were made with white shapes on top rather than as real
holes; make them compound paths.

**Fine detail is lost or blurred in the print.** See
[section 7](#7-detail-depth-and-what-will-print): enlarge or simplify the
artwork, try matte filament, and use thinner layers through the
artwork's band.

**Rendering a round bin is slow.** That's the wrapping; see
[section 6](#6-flat-faces-and-wrapped-artwork) for faster drafts.

## 12. Version history

- **0.9** (Needle Bin I): the bin, by Bob Drzyzgula.
- **0.10**: recessed artwork on the side: flat on a face for bins with few
  faces, wrapped around round bins, and an option to fit artwork to the
  face. It started with a text label (string, font and size) and one SVG
  logo; the text label was then replaced by a second SVG slot, since text
  laid out in a drawing program as SVG gives more control.
- **0.11**: sizing as a percentage of the face's width or height,
  measured on the bin after rotation, or in millimeters measured the same
  way; artwork centered halfway up the side by default; warnings for
  artwork running off the bin; presets and example artwork.

## 13. Credits and license

Needle Bin II was designed, printed and tested by Bob Drzyzgula, from his
Needle Bin I. The artwork features, the example artwork and this guide were
written by Claude (Anthropic) at his direction.

Released under the MIT License; see `LICENSE`.
