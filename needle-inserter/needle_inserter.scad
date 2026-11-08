// needle_inserter.scad
// Needle inserter for HAx1 / 15x1 / 130/705 H flat-shank sewing machine needles.
//
// Written by Claude (Anthropic) at the direction of Bob Drzyzgula, Nov 2026.
//
// Use: drop the needle point-first into the pocket in the head, with the
// shank's flat against the pocket's flat wall. The blade passes through the
// neck hole and the shoulder seats on it. Pinch the vertical paddle grip
// between thumb and forefinger, raise the needle into the clamp, tighten the
// clamp, then draw the tool straight down off the blade.
//
// Coordinates: the needle axis is Z, through the origin. The shaft and grip
// run along -X from the head. Z = 0 is a common flat bottom, so the part
// prints upright with no supports, and both needle holes print vertically.
//
// Needs BOSL2: https://github.com/BelfrySCAD/BOSL2

include <BOSL2/std.scad>
include <BOSL2/skin.scad>

/* [Needle (HAx1 / 15x1 / 130/705 H)] */
// Shank diameter. Groz-Beckert and Organ give 2.04; ISMACS measured 2.02
shank_d = 2.04; // [1.90:0.01:2.20]
// Shank across the flat. NOT published by makers: measure yours with calipers
shank_af = 1.75; // [1.40:0.01:2.00]
// Largest blade that must pass the neck: NM 140 (size 22) = 1.40
blade_max = 1.40; // [0.60:0.05:1.60]

/* [Holes, as drawn (printed holes come out small)] */
// Added to shank diameter for the pocket
pocket_clr = 0.25; // [0:0.01:0.60]
// Added to across-flat for the pocket's flat wall
af_clr = 0.20; // [0:0.01:0.60]
// Neck hole, short axis (across the flat's normal). Must stop the shoulder (< shank_d)
neck_d = 1.80; // [1.20:0.01:2.00]
// Extra length of the neck hole's long axis, which lies parallel to the flat,
// to clear the swelling of the blade around the eye
neck_oval = 0.25; // [0:0.01:0.60]
// Depth of the keyed pocket above the shoulder seat
pocket_depth = 2.5; // [1.0:0.1:10.0]
// Length of the neck hole below the seat
neck_len = 3.0; // [0.8:0.1:8.0]
// Chamfer at the bottom of the neck hole (offsets first-layer squish on the plate)
neck_chamfer = 0.4; // [0:0.05:1.0]
// Lead-in chamfer at the pocket mouth
pocket_chamfer = 0.5; // [0:0.05:1.0]
// Where the pocket flat faces: 0 = toward the tip (away from the grip),
// 90 = left, -90 = right, as seen holding the grip with the head pointing away
flat_angle = 0; // [-180:15:180]

/* [Spring tab (forms the pocket's flat wall)] */
spring_tab = true;
// Tab thickness (0.8 = two 0.4 mm perimeters)
tab_t = 0.8; // [0.4:0.05:1.6]
// Tab width, along the flat; keep it wider than the flat's chord
tab_w = 2.0; // [1.0:0.05:3.0]
// How far the tab's face stands into the pocket past the nominal flat, at rest
tab_preload = 0.15; // [0:0.01:0.50]
// Gap around the tab (sides and back)
tab_gap = 0.5; // [0.3:0.05:1.0]
// Tab root, measured down from the shoulder seat (longer tab = softer spring)
tab_root_below_seat = 1.0; // [0:0.1:2.5]
// Height the tab stands above the top of the head
tab_ext = 1.0; // [0:0.1:3.0]
// Lead-in chamfer on the top inside edge of the tab
tab_chamfer = 0.4; // [0:0.05:0.8]

/* [Head] */
// Wall around the pocket (max about 3 mm before the clamp area gets crowded)
head_wall = 2.6; // [1.0:0.1:3.0]
// Extra head length on the flat side (the collar needn't be round)
head_front_ext = 0.0; // [0:0.1:3.0]

/* [Shaft and grip] */
// Shaft diameter where it joins the head
shaft_d = 6.0; // [3.0:0.1:10.0]
// Straight shaft, from needle axis to start of transition
shaft_len = 15; // [5:1:60]
// Shaft-to-grip blend length
trans_len = 18; // [5:1:40]
// Grip length along the tool
grip_len = 25; // [15:1:80]
// Grip height (vertical, parallel to the needle)
grip_h = 13; // [8:0.5:35]
// Grip thickness (between thumb and forefinger)
grip_t = 6.5; // [3:0.1:12]
// Radius rounding off the end of the grip
end_r = 3.0; // [0:0.1:6]
// Amount trimmed off the bottom of round sections to make a flat print base
base_cut = 0.6; // [0:0.05:2]

/* [Finger dimples] */
dimples = true;
dimple_depth = 0.7; // [0.1:0.1:2.0]
// Dimple size on the face: length along the tool, and height
dimple_len = 18; // [5:1:40]
dimple_h = 12; // [4:1:30]

/* [Rendering] */
$fn = 64;
loft_steps = 24; // [8:1:80]

// ---------------------------------------------------------------------------
// Derived
pocket_d  = shank_d + pocket_clr;
pocket_af = shank_af + af_clr;          // D-pocket: center to flat = pocket_af - pocket_d/2
head_d    = pocket_d + 2 * head_wall;
head_h    = pocket_depth + neck_len;
total_len = shaft_len + trans_len + grip_len;
eps = 0.01;

assert(neck_d > blade_max, "neck_d must be larger than blade_max");
assert(neck_d < shank_d,   "neck_d must be smaller than shank_d or the needle falls through");
assert(neck_d + neck_oval > blade_max, "neck hole's long axis must pass blade_max");
assert(pocket_af < pocket_d, "across-flat must be less than the pocket diameter");
assert(shaft_d <= head_d + eps, "shaft_d should not exceed the head diameter");
assert(!spring_tab || tab_root_below_seat < neck_len,
       "tab root must stay above the bottom of the head");
assert(!spring_tab ||
       norm([pocket_af - pocket_d / 2 - tab_preload + tab_t + tab_gap, tab_w / 2 + tab_gap])
           <= head_d / 2 - 0.8,
       "spring tab slot leaves less than 0.8 mm of wall: raise head_wall or head_front_ext");

// ---------------------------------------------------------------------------
// Cross-section profile: a stadium t wide by h tall (rounded top and bottom),
// centered on X, with its bottom at y = -base_cut. When h == t it is a circle.
// Fixed point count so skin() can join any two of them.
function stadium(t, h, n = 64) =
    let(r = t / 2, c = max(0, (h - t) / 2), yc = h / 2 - base_cut)
    [for (i = [0 : n - 1])
        let(a = (i + 0.5) * 360 / n)
        [r * cos(a), r * sin(a) + (sin(a) >= 0 ? c : -c) + yc]];

function smooth(u) = let(v = max(0, min(1, u))) v * v * v * (v * (6 * v - 15) + 10);

// Profile at distance s from the needle axis, measured toward the grip end.
function sect(s) =
    let(
        u   = (s - shaft_len) / trans_len,
        k   = smooth(u),
        t   = shaft_d + (grip_t - shaft_d) * k,
        h   = shaft_d + (grip_h - shaft_d) * k,
        se  = s - (total_len - end_r),               // into the end rounding
        ins = (end_r > 0 && se > 0) ? end_r - sqrt(max(0, end_r * end_r - se * se)) : 0
    )
    stadium(max(0.3, t - 2 * ins), max(0.3, h - 2 * ins));

function stations() =
    concat(
        [0, shaft_len],
        [for (i = [1 : loft_steps]) shaft_len + trans_len * i / loft_steps],
        end_r > 0
            ? concat([total_len - end_r],
                     [for (i = [1 : 12]) total_len - end_r + end_r * sin(90 * i / 12)])
            : [total_len]
    );

// The lofted shaft + grip. Skin is built along +Z, then turned so skin Z -> world -X,
// profile X -> world Y, profile Y -> world Z.
module body() {
    zs = stations();
    multmatrix([[0, 0, -1, 0], [-1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 0, 1]])
        skin([for (s = zs) sect(s)], z = zs, slices = 0);
}

// Head: a round collar, optionally stretched toward the flat side.
module head()
    rotate([0, 0, flat_angle])
        hull() {
            cylinder(d = head_d, h = head_h);
            if (head_front_ext > 0) translate([head_front_ext, 0, 0]) cylinder(d = head_d, h = head_h);
        }

// Geometry of the flat and the tab, in the frame where the flat faces +X.
flat_x  = pocket_af - pocket_d / 2;          // nominal flat, from the needle axis
tab_x0  = flat_x - tab_preload;              // tab face, at rest
tab_x1  = tab_x0 + tab_t;
tab_z0  = neck_len - tab_root_below_seat;    // tab root
tab_z1  = head_h + tab_ext;                  // tab top

// Neck hole: oval, long axis parallel to the flat, with a bottom chamfer.
module neck_cut() {
    sy = (neck_d + neck_oval) / neck_d;
    rotate([0, 0, flat_angle]) scale([1, sy, 1]) {
        translate([0, 0, -1]) cylinder(d = neck_d, h = neck_len + 1 + eps);  // stop at the seat
        if (neck_chamfer > 0)
            translate([0, 0, -eps])
                cylinder(d1 = neck_d + 2 * neck_chamfer + 0.02, d2 = neck_d, h = neck_chamfer + eps);
    }
}

// Keyed pocket, with the lead-in chamfer on the round side only, so the
// flat wall runs straight up to the top face of the head.
module pocket_cut() {
    seat_z = neck_len;
    rotate([0, 0, flat_angle])
        intersection() {
            union() {
                translate([0, 0, seat_z]) cylinder(d = pocket_d, h = pocket_depth + 1);
                if (pocket_chamfer > 0)
                    translate([0, 0, head_h - pocket_chamfer])
                        cylinder(d1 = pocket_d, d2 = pocket_d + 2 * pocket_chamfer + 0.02,
                                 h = pocket_chamfer + 1);
            }
            flat_keep(seat_z);
        }
}

// Half-space on the near side of the pocket's flat wall (flat faces +X before
// rotation), from z0 up through the top of the head.
module flat_keep(z0) {
    w = pocket_d + 4 * pocket_chamfer + 2;
    translate([flat_x - w, -w / 2, z0])
        cube([w, w, head_h - z0 + 1]);
}

// U-shaped slot that frees the tab on both sides and behind.
module tab_cavity() {
    w = tab_w + 2 * tab_gap;
    rotate([0, 0, flat_angle])
        translate([tab_x0 - eps, -w / 2, tab_z0])
            cube([tab_t + tab_gap + eps, w, head_h - tab_z0 + 1]);
}

// The cantilevered tab: rooted at tab_z0, free at the top, with a lead-in
// chamfer on its top inside edge.
module tab() {
    c = min(tab_chamfer, tab_t - 0.2);
    rotate([0, 0, flat_angle])
        rotate([90, 0, 0])
            linear_extrude(height = tab_w, center = true)
                polygon([[tab_x0, tab_z0 - eps], [tab_x1, tab_z0 - eps], [tab_x1, tab_z1],
                         [tab_x0 + c, tab_z1], [tab_x0, tab_z1 - c]]);
}

module dimple_cuts() {
    if (dimples) {
        xc = -(shaft_len + trans_len + (grip_len - end_r) / 2);
        zc = grip_h / 2 - base_cut;
        for (sy = [-1, 1]) {
            // shallow ellipsoid: its surface dips dimple_depth into the face
            R = 6;  // thickness-direction semi-axis of the cutter
            translate([xc, sy * (grip_t / 2 + R - dimple_depth), zc])
                scale([dimple_len / 2, R, dimple_h / 2]) sphere(r = 1, $fn = 48);
        }
    }
}

module needle_inserter() {
    difference() {
        union() {
            difference() {
                intersection() {
                    union() {
                        body();
                        head();
                    }
                    print_base();
                }
                pocket_cut();
                if (spring_tab) tab_cavity();
                dimple_cuts();
            }
            if (spring_tab) intersection() { tab(); print_base(); }
        }
        neck_cut();   // last, so nothing added back can narrow it
    }
}

// Everything at or above z = 0: the flat print base.
module print_base()
    translate([-total_len - head_d, -50, 0]) cube([total_len + 2 * head_d + 10, 100, 100]);

needle_inserter();
