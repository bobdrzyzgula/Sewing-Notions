// point_turner.scad
// Curved point turner: a blunt-pointed blade for pushing out the corners of
// a bag, pillow, collar or other piece after it has been turned right side
// out. Small, medium and large presets, or set your own.
//
// Written by Claude (Anthropic) at the direction of Bob Drzyzgula, Nov 2026.
//
// Shape: the tool is lofted through a chain of cross-sections along a path. The
// path is straight at the tip, bends gently through the neck, and runs
// straight again through the grip. The blade is flat, with its broad face
// in the plane you would lay a bag down in; the bend is across the
// thickness, so the handle rises away from the work.
//
// Printing: the tool lies on its side, with one edge of the blade (and a
// narrow flat along the grip) on the bed. The bend lies in the bed plane.
// No supports; every overhang is 45 degrees or less except the tiny
// rounding at the very tip. Each extrusion line runs along the tool, so a
// push on the tip loads the lines, not the layer bonds.
//
// Coordinates: the tip is at the origin, the tool runs along +X and bends
// toward +Y. Z = 0 is the bed. The blade's broad face is vertical (XZ).
//
// No libraries needed.

/* [Size] */
// Preset to make. "all" lays the three presets side by side on one plate
size = "medium"; // [small, medium, large, custom, all]

/* [Tip (same for every size)] */
// Diameter of the blunt nub at the very tip. Smaller pokes into tighter
// points but is likelier to push through a loose weave
tip_d = 1.6; // [0.8:0.1:3.0]
// Included angle of the point, seen face-on. Must be sharper than the
// corners you turn (most are 90; collar points can be 60 or less)
tip_angle = 35; // [20:1:60]
// Distance over which the thickness grows from the nub to the full blade
thick_taper = 22; // [8:1:50]

/* [Bend] */
// Total bend from tip to grip, degrees. 0 = straight
bend_deg = -1; // [-1:1:45]
// Where the bend starts and ends, as fractions of the length (-1 = preset)
bend_start = 0.18; // [0.0:0.01:0.9]
bend_end = 0.55; // [0.1:0.01:1.0]

/* [Butt end] */
// round = domed end for the palm; creaser = thin rounded paddle for
// finger-pressing seams open
butt_style = "round"; // [round, creaser]
// Creaser paddle thickness
creaser_t = 2.6; // [1.6:0.1:5.0]
// Hanging hole through the butt (side to side), 0 = none. Keep it smaller
// than the grip height less about 5 mm
hang_hole_d = 0; // [0:0.5:8]

/* [Cross-section] */
// Width of the flat on the bed, as a fraction of the half-thickness.
// Bigger = steadier on the bed and a plainer flat on one side of the grip
flat_frac = 0.5; // [0.2:0.05:0.9]

/* [Custom size (used when size = custom)] */
c_length = 114; // [50:1:250]
c_reach = 42; // [15:1:150]
c_blade_t = 3.5; // [2.0:0.1:8.0]
c_blade_h = 11; // [5:0.5:25]
c_grip_t = 12; // [6:0.5:30]
c_grip_h = 15; // [6:0.5:35]
c_swell_len = 16; // [5:1:40]
c_groove = true;
c_groove_depth = 1.0; // [0:0.1:3.0]
c_groove_w = 16; // [6:1:40]
c_pads = false;
// Extra thickness of the palm swell in the middle of the grip
c_belly = 1.0; // [0:0.1:4.0]
c_end_len = 10; // [3:1:40]
c_bend = 20; // [0:1:45]

/* [Plate and quality] */
// Gap between tools when size = all
plate_gap = 6; // [2:1:30]
// Cross-sections along the tool (more = smoother, slower)
stations = 90; // [30:5:240]
// Points around each cross-section, and the pads' and hole's smoothness
$fn = 64; // [24:8:240]

/* [Hidden] */
// Presets. The tip is the same on all three: a corner doesn't get bigger
// because the tool does. What grows is the reach (tip to grip) and the
// grip, and with it the room for a finger groove and pinch pads.
//   length   overall length
//   reach    tip to the start of the grip swell
//   blade_t/h  blade thickness and face width where the tip taper ends
//   grip_t/h   grip thickness (across the bend) and height (across the face)
//   swell_len  length of the blade-to-grip swell
//   groove...  finger groove (waist) just behind the swell
//   pads       shallow pinch pads on both faces of the waist
//   belly      palm swell: extra thickness midway between waist and butt
//   end_len    length of the rounding at the butt
//   bend       default bend, degrees
SMALL = [
    ["length", 76], ["reach", 30], ["blade_t", 3.0], ["blade_h", 9],
    ["grip_t", 9], ["grip_h", 11.5], ["swell_len", 12],
    ["groove", false], ["groove_depth", 0], ["groove_w", 10],
    ["pads", false], ["belly", 0], ["end_len", 7], ["bend", 15]];
MEDIUM = [
    ["length", 114], ["reach", 42], ["blade_t", 3.5], ["blade_h", 11],
    ["grip_t", 12], ["grip_h", 15], ["swell_len", 16],
    ["groove", true], ["groove_depth", 1.0], ["groove_w", 16],
    ["pads", false], ["belly", 1.0], ["end_len", 10], ["bend", 20]];
LARGE = [
    ["length", 152], ["reach", 52], ["blade_t", 4.0], ["blade_h", 12],
    ["grip_t", 15], ["grip_h", 19], ["swell_len", 20],
    ["groove", true], ["groove_depth", 1.3], ["groove_w", 22],
    ["pads", true], ["belly", 2.0], ["end_len", 13], ["bend", 20]];
CUSTOM = [
    ["length", c_length], ["reach", c_reach], ["blade_t", c_blade_t],
    ["blade_h", c_blade_h], ["grip_t", c_grip_t], ["grip_h", c_grip_h],
    ["swell_len", c_swell_len], ["groove", c_groove],
    ["groove_depth", c_groove_depth], ["groove_w", c_groove_w],
    ["pads", c_pads], ["belly", c_belly], ["end_len", c_end_len], ["bend", c_bend]];

// Pinch pads: chord across the face, depth
PAD_CHORD = 13;
PAD_DEPTH = 0.8;
// Smallest cross-section the butt rounding tapers to before the end is capped
END_MIN = 1.2;

function row(name) = name == "small" ? SMALL : name == "large" ? LARGE
    : name == "custom" ? CUSTOM : MEDIUM;
function pv(r, k) = r[search([k], r)[0]][1];

// ---------- helpers ----------
function clamp01(x) = max(0, min(1, x));
function sstep(x) = let(u = clamp01(x)) u * u * (3 - 2 * u);
function easeout(x) = let(u = clamp01(x)) 1 - (1 - u) * (1 - u);
// cos^2 bump: 1 at c, 0 beyond c +/- w/2
function bump(s, c, w) = abs(s - c) >= w / 2 ? 0 : pow(cos(180 * (s - c) / w), 2);
// smooth minimum, k = blend width
function smin(a, b, k) = let(h = clamp01(0.5 + 0.5 * (b - a) / k))
    b * (1 - h) + a * h - k * h * (1 - h);
// quarter-ellipse factor for the butt rounding: 1 before the rounding, 0 at L
function endf(s, L, e) = s <= L - e ? 1 : sqrt(max(0, 1 - pow((s - (L - e)) / e, 2)));

// ---------- profiles along the length (s = 0 at the tip) ----------
function groove_c(r) = pv(r, "reach") + pv(r, "swell_len") + pv(r, "groove_w") / 2 + 1;

// palm swell, centered between the waist and the butt
function belly(r, s) = let(L = larc(r), g0 = groove_c(r) + pv(r, "groove_w") / 2,
    c = (g0 + L - pv(r, "end_len")) / 2, w = 2 * (L - g0))
    pv(r, "belly") * bump(s, c, w);

// Face width (Z)
function prof_h(r, s) =
    let(L = larc(r), bh = pv(r, "blade_h"),
        point = smin(tip_d + s * tan(tip_angle), bh, 2.5),
        swell = (pv(r, "grip_h") - bh) * sstep((s - pv(r, "reach")) / pv(r, "swell_len")),
        grv = pv(r, "groove") ? 2 * pv(r, "groove_depth") * bump(s, groove_c(r), pv(r, "groove_w")) : 0,
        raw = point + swell - grv + belly(r, s) * pv(r, "grip_h") / pv(r, "grip_t"))
    max(raw * endf(s, L, pv(r, "end_len")), END_MIN, prof_t(r, s));

// Thickness (Y, across the bend)
function prof_t(r, s) =
    let(L = larc(r), bt = pv(r, "blade_t"),
        wedge = tip_d + (bt - tip_d) * easeout(s / thick_taper),
        swell = (pv(r, "grip_t") - bt) * sstep((s - pv(r, "reach")) / pv(r, "swell_len")),
        grv = pv(r, "groove") ? 2 * pv(r, "groove_depth") * bump(s, groove_c(r), pv(r, "groove_w")) : 0,
        body = wedge + swell - grv + belly(r, s),
        // creaser: thin down to a paddle over the last part of the grip
        cl = 2 * pv(r, "end_len") + 10,
        cre = butt_style == "creaser"
            ? body - (body - creaser_t) * sstep((s - (L - cl - 2 * pv(r, "end_len"))) / cl)
            : body,
        ef = butt_style == "creaser" ? 1 : endf(s, L, pv(r, "end_len")))
    max(cre * ef, END_MIN);

// ---------- path ----------
// The preset length is the straight end-to-end length. The path is drawn
// along its arc, so stretch the arc until its chord comes out right (the
// bend shape scales with length, so one correction is exact).
function chord_x(r, Lc) = let(n = 200, ds = Lc / n)
    [for (i = 0, x = 0; i <= n; x = x + ds * cos(heading_l(r, Lc, (i + 0.5) * ds)), i = i + 1) x][n];
function larc(r) = let(Ln = pv(r, "length") - tip_d / 2) Ln * Ln / chord_x(r, Ln);
function heading_l(r, L, s) =
    bend_of(r) * sstep((s / L - bend_start) / max(0.01, bend_end - bend_start));
function bend_of(r) = bend_deg >= 0 ? bend_deg : pv(r, "bend");
function heading(r, s) = heading_l(r, larc(r), s);
function path(r, n) = let(L = larc(r), ds = L / n)
    [for (i = 0, p = [0, 0]; i <= n;
          p = p + ds * [cos(heading(r, (i + 0.5) * ds)), sin(heading(r, (i + 0.5) * ds))],
          i = i + 1) p];

// ---------- cross-section ----------
// An ellipse (half-thickness a) on a flat of half-width w, with straight
// sides from the flat up to the ellipse at exactly 45 degrees, total height
// h. Returned as a ring of SEC points (u across the thickness, v up).
SEC = max(24, ceil($fn));   // points around each cross-section
function sec_b(a, h, w) = let(hw = max(h + w, a + 0.01)) (hw * hw - a * a) / (2 * hw);
function sec_px(a, b) = a * a / sqrt(a * a + b * b);
function sec_w(a, h) = let(w0 = flat_frac * a, b0 = sec_b(a, h, w0))
    min(w0, 0.9 * sec_px(a, b0));
function section_pts(t, h) =
    let(a = t / 2, w = sec_w(a, h), b = sec_b(a, h, w), zc = h - b,
        tp = atan2(-b, a), m = SEC - 2)
    concat([[w, 0]],
        [for (k = [0 : m - 1]) let(u = tp + (180 - 2 * tp) * k / (m - 1))
            [a * cos(u), max(0, zc + b * sin(u))]],
        [[-w, 0]]);
function section_zc(t, h) = let(a = t / 2, w = sec_w(a, h)) h - sec_b(a, h, w);

// place a 2D ring at path point p with heading th (u along the left normal)
function ring3(p, th, pts) = [for (q = pts)
    [p[0] - q[0] * sin(th), p[1] + q[0] * cos(th), q[1]]];

// ---------- the tool ----------
module point_turner(name) {
    r = row(name);
    L = larc(r);
    n = stations;
    ds = L / n;
    P = path(r, n);
    // tip nub: rings shrinking on a quarter circle ahead of s = 0, about the
    // bed edge, so the point stays straight along the bottom
    nc = 6;
    rn = tip_d / 2;
    tipr = [for (k = [nc : -1 : 1]) let(f = k / nc, phi = 90 * f,
            sc = max(0.04, cos(phi)), back = rn * sin(phi))
        ring3([P[0][0] - back, P[0][1]], 0,
              [for (q = section_pts(prof_t(r, 0), prof_h(r, 0))) [q[0] * sc, q[1] * sc]])];
    body = [for (i = [0 : n]) ring3(P[i], heading(r, i * ds),
            section_pts(prof_t(r, i * ds), prof_h(r, i * ds)))];
    rings = concat(tipr, body);
    R = len(rings);
    pts = [for (rg = rings) each rg];
    faces = concat(
        [[for (j = [0 : SEC - 1]) j]],
        [for (i = [0 : R - 2], j = [0 : SEC - 1], tri = [0, 1])
            let(a = i * SEC + j, b = i * SEC + (j + 1) % SEC)
            tri == 0 ? [a, a + SEC, b + SEC] : [a, b + SEC, b]],
        [[for (j = [SEC - 1 : -1 : 0]) (R - 1) * SEC + j]]);
    difference() {
        polyhedron(pts, faces, convexity = 6);
        // pinch pads on both faces of the waist
        if (pv(r, "pads")) {
            s = groove_c(r);
            i = round(s / ds);
            t = prof_t(r, s); h = prof_h(r, s);
            Rs = (PAD_CHORD * PAD_CHORD / 4 + PAD_DEPTH * PAD_DEPTH) / (2 * PAD_DEPTH);
            for (side = [-1, 1])
                translate([P[i][0], P[i][1], section_zc(t, h)])
                    rotate([0, 0, heading(r, s)])
                        translate([0, side * (t / 2 + Rs - PAD_DEPTH), 0])
                            scale([1.6, 1, 1]) sphere(r = Rs, $fn = 96);
        }
        // hanging hole, through the thickness (horizontal as printed), with a
        // pointed top so it bridges at 45 degrees with no support
        if (hang_hole_d > 0) {
            s = L - pv(r, "end_len") - hang_hole_d / 2 - 3;
            i = round(s / ds);
            zc = section_zc(prof_t(r, s), prof_h(r, s));
            translate([P[i][0], P[i][1], zc]) rotate([0, 0, heading(r, s)])
                rotate([90, 0, 0]) linear_extrude(60, center = true)
                    hull() {
                        circle(d = hang_hole_d, $fn = 32);
                        translate([0, hang_hole_d / 2 * sqrt(2)]) square(0.01, center = true);
                    }
        }
    }
}

// ---------- output ----------
// Y extent of a tool, for laying out the plate
function width_of(nm) = let(r = row(nm), P = path(r, stations))
    max([for (p = P) p[1]]) + pv(r, "grip_t") / 2 + pv(r, "blade_t") / 2;

if (size == "all") {
    // stack across Y, each tool's bend clearing the one before
    names = ["large", "medium", "small"];
    for (k = [0 : 2]) {
        off = k == 0 ? 0 : (width_of(names[0]) + plate_gap)
            + (k == 2 ? width_of(names[1]) + plate_gap : 0);
        translate([0, off, 0]) point_turner(names[k]);
    }
} else {
    point_turner(size);
}
