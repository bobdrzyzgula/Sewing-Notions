# Tilt Prop — User's Guide

The Tilt Prop was designed by Bob Drzyzgula. The OpenSCAD model and this
guide were written by Claude (Anthropic) at his direction.

## Contents

1. [What it is](#1-what-it-is)
2. [How it works](#2-how-it-works)
3. [Measuring your machine](#3-measuring-your-machine)
4. [Printing](#4-printing)
5. [Using it](#5-using-it)
6. [Settings reference](#6-settings-reference)
7. [Credits and license](#7-credits-and-license)

## 1. What it is

To oil a sewing machine or work on its mechanism, you tip it back in its
base so the underside faces you. Many bases have nothing to hold it there,
and a machine leaning back too far can tip the base up. The Tilt Prop stands on the table behind the base and catches the
machine as it tips back, so the machine rests on it with both your hands
free, and its weight goes straight down into the table.

![Two tilt props: a cradle for a round arm, and a flat top sloped
20°](../images/tilt-prop.png)

It was spun off from the
[VSM Base](https://github.com/bobdrzyzgula/VSM-Base), whose main model
also makes this prop, sized from its machine profiles.

## 2. How it works

- **The top** is either a **cradle**, a half-round trough for a round arm,
  or **flat**. Either can slope, rising toward the back, to meet a part
  that comes to rest at an angle. The top turns about its width axis, the
  cradle's axis.
- **The foot** is sized so the prop won't tip: a load on the top, pressing
  square to it, can lean a further `stability_angle` (15°) either way
  before its line would pass the foot's edge. A knock, or a sloping top,
  won't push the prop over. A sloping top gets a longer foot.
- **Two tapered legs**, front and back, carry the top. The opening between
  them is gabled, so the prop prints upright without supports.

The console reports the top, the height and the foot's size.

## 3. Measuring your machine

1. Tip the machine back to where you want it to rest, usually about 90°.
   Check the angle with a level or a tilt gauge.
2. Choose what the prop will catch: the arm, for most machines, or some
   other solid part. Avoid anything that moves or that could be bent.
3. Measure from the table to that part. For a cradle, measure to the
   underside of the arm, where the cradle's bottom will be; for a flat
   top, to the middle of the surface that will rest on it. That is
   `height`.
4. For a cradle, measure the arm's diameter where it will rest. Set
   `cradle_r` to half of that plus a little; `cradle_clear` adds a further
   1 mm. For a Singer 99K, whose arm is 1.75 to 2" across there, 1" works.
5. If the part comes to rest at an angle, measure it and set `slope`.

## 4. Printing

- Print standing on the foot, with no supports.
- 15% infill is plenty.
- Line the top with felt or cork, so it doesn't mark the machine's finish.

## 5. Using it

1. Stand the prop on the table behind the base, under the part it will
   catch.
2. Tip the machine back slowly until it settles onto the prop.
3. When you're done, lift the machine forward off the prop before moving
   it.

## 6. Settings reference

Dimensions are in millimeters; the defaults are in inches converted to mm.

### Top

| Setting | Default | Meaning |
|---|---|---|
| `height` | 152.4 (6") | Table to the cradle's bottom, or to the middle of the flat top's surface |
| `top` | cradle | `cradle` or `flat` |
| `cradle_r` | 25.4 (1") | Cradle radius: the arm's radius plus a little |
| `width` | 38.1 (1.5") | Width along the arm (the cradle's length, or the flat top's width) |
| `flat_length` | 50 | Flat top's length, front to back |
| `slope` | 0 | Degrees from level, rising toward the back (negative: toward the front) |

### Foot and legs

| Setting | Default | Meaning |
|---|---|---|
| `stability_angle` | 15 | How far a load may lean past square to the top before the prop would tip; sets the foot's size |
| `foot_t` | 5 | Foot thickness |
| `leg_t` | 10 | Leg thickness, front and back |
| `cradle_clear` | 1 | Clearance added to the cradle's radius |

## 7. Credits and license

Designed by Bob Drzyzgula. The OpenSCAD model and this guide were written
by Claude (Anthropic) at his direction. The same file is kept in the VSM
Base repository.

Released under the [MIT License](../LICENSE).
