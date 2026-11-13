// pincushion.scad -- two-part snap-together pincushion with fabric pattern generator
//
// Written by Claude (Anthropic) at the direction of Bob Drzyzgula.
// License: MIT
//
// Concept: a round CUP is filled with batting (mounded into a dome) and draped
// with fabric. A COVER (shroud) with an inward lip is pressed down over it. The
// cup carries sawtooth ribs on its outside; the cover carries matching ribs on
// its inside. Pressed together with the fabric between them, the teeth nest
// through the fabric and ratchet: easy on, hard off. Nothing rotates, so the
// fabric can't be twisted the way a threaded cover would twist it.
//
// The fabric pattern (part = "pattern", export as SVG/DXF, print at 100%) is a
// disk with N tabs. V-notches start under the lip so the excess circumference
// at the rim is cut away and the tabs lie flat down the cup wall, hidden under
// the cover.
//
// Print orientation:
//   cup   -- upright, as modelled (rib retention faces are 45 deg overhangs)
//   cover -- lip DOWN on the plate (part = "cover" is already flipped for you)
// PETG recommended for the cover: it has to stretch ~2% in hoop to pass the ribs.
//
// Artwork: two SVG locations on the outside of the cover (wrapped onto the
// cylinder, engraved, inlaid or raised) and one under the cup (engraved or
// inlaid; it prints on the plate). For multi-colour prints, export "cup" and
// "cover" as 3MF with lazy union on: the artwork comes out as its own coloured
// object. The *_only and *_art parts give the pieces separately for STL use.
//
// Version 1.2 (cup sized by inner diameter for washer weights). UNTESTED: not yet printed.

/* [Part] */
part = "assembly"; // [assembly:Preview - assembled, cutaway:Preview - cutaway, section:Preview - half cross-section (2D), cup:Cup with bottom artwork (print orientation), cover:Cover with side artwork (print orientation), cup_only:Cup without artwork solid, cover_only:Cover without artwork solid, cup_art:Cup bottom artwork solid only, cover_art:Cover side artwork solids only, pattern:Fabric pattern (2D - export SVG/DXF), print_plate:Cup and cover together]

/* [Size] */
// Inside diameter of the cup (77.5 fits seven 1"-OD washers in a hexagonal cluster)
cup_id = 77.5; // [30:0.5:160]
// Total height of the cup, base to rim
cup_h = 26; // [15:0.5:80]
// Cup wall thickness
wall = 3.0; // [1.6:0.1:6]
// Cup floor thickness
floor_t = 2.4; // [1.2:0.1:6]

// Rounding where the inside floor meets the wall (keep below the washer thickness)
floor_round = 0.8; // [0:0.1:4]

/* [Washer weights (under the batting)] */
// Layers of washers lining the floor (0 = none); used for the fit check, depth and mass report
washer_layers = 2; // [0:1:6]
// Washer outside diameter (3/8" USS flat washer: 1.000" = 25.4 mm)
washer_od = 25.4; // [10:0.1:60]
// Washer inside diameter (3/8" USS: 0.438" = 11.1 mm)
washer_id = 11.1; // [0:0.1:40]
// Washer thickness (3/8" USS nominal 0.083" = 2.1 mm)
washer_t = 2.1; // [0.5:0.05:6]
// Washers per layer: 7 = hexagonal cluster (needs 3 x OD), 1 = single centre washer
washers_per_layer = 7; // [1, 7]

/* [Fabric and dome] */
// Compressed fabric thickness (quilting cotton ~0.3, wool felt ~1.0)
fabric_t = 0.35; // [0.1:0.05:2]
// Planned dome height of the batting above the rim
dome_h = 14; // [0:0.5:60]
// Number of tabs in the fabric pattern
tabs = 12; // [6:1:36]
// Fraction of the cup circumference the tabs cover (less than 1 leaves gaps so tabs never overlap)
tab_fill = 0.88; // [0.5:0.01:1]
// Shrink the dome portion of the pattern by this percent so the top ends up taut
taut_pct = 2; // [0:0.5:10]
// Keep tab ends this far above the bottom of the cover skirt
tab_margin = 1.5; // [0:0.5:5]
// Corner rounding on the tab ends
tab_round = 2; // [0:0.5:5]

/* [Snap ribs] */
// Number of rib rows
rib_rows = 4; // [1:1:10]
// Radial height of each rib
rib_h = 0.9; // [0.3:0.05:2]
// Vertical pitch of the ribs
rib_pitch = 3.0; // [1.5:0.1:6]
// Lead-in ramp angle, measured from vertical (smaller = easier on)
lead_angle = 30; // [15:1:60]
// Retention face angle, measured from horizontal (45 is the steepest that prints clean)
ret_angle = 45; // [30:1:60]
// Radial clearance added to the fabric thickness between nested teeth
rib_clear = 0.10; // [0:0.05:0.6]

/* [Cover] */
// Cover wall thickness (outside the rib recess)
cover_wall = 3.0; // [1.6:0.1:6]
// Lip thickness
lip_t = 2.0; // [1.2:0.1:5]
// How far the lip reaches inward past the cup's inner wall
lip_reach = 3.0; // [0:0.5:12]
// Plain skirt below the bottom rib row
skirt_extra = 2.0; // [0:0.5:10]
// Visible gap between the cover and the cup plinth when seated
reveal = 1.0; // [0:0.1:4]

/* [Details] */
// Rounding of the cup rim's outer edge (fabric wraps over it)
rim_round_o = 1.5; // [0.4:0.1:4]
// Rounding of the cup rim's inner edge
rim_round_i = 0.8; // [0.4:0.1:4]
// Plain band between the rim rounding and the first rib
rim_land = 1.0; // [0:0.25:6]
// Edge chamfers
chamfer = 0.6; // [0:0.1:2]
// Explode distance for the assembly view
explode = 0; // [0:1:60]

/* [Cover artwork, location 1 (SVG)] */
// Wrapped onto the cover's outer wall. Inlay on a vertical wall means a colour change on every layer the art spans.
side1_mode = "none"; // [none:None, engrave:Engrave (recessed), inlay:Inlay (flush, second colour), raise:Raised]
side1_file = "examples/spool.svg";
// Angle around the cover where the artwork is centred
side1_angle = 0; // [0:1:359]
// Artwork height (mm, 0 = 60% of the plain band on the cover)
side1_height = 0; // [0:0.5:60]
// Artwork width along the curve (mm, 0 = keep proportions)
side1_width = 0; // [0:0.5:200]
// Move the artwork up (+) or down (-) from the middle of the band
side1_z_shift = 0; // [-20:0.25:20]
side1_rotate = 0; // [0:1:359]

/* [Cover artwork, location 2 (SVG)] */
side2_mode = "none"; // [none:None, engrave:Engrave (recessed), inlay:Inlay (flush, second colour), raise:Raised]
side2_file = "examples/spool.svg";
side2_angle = 180; // [0:1:359]
side2_height = 0; // [0:0.5:60]
side2_width = 0; // [0:0.5:200]
side2_z_shift = 0; // [-20:0.25:20]
side2_rotate = 0; // [0:1:359]

/* [Cover artwork, both locations] */
// Engrave / inlay depth or raised height (mm)
side_depth = 0.6; // [0.2:0.1:1.5]
// Width of the flat strips the artwork is wrapped from (smaller = smoother, slower)
side_strip = 0.5; // [0.2:0.05:2]

/* [Bottom artwork (SVG)] */
// Under the cup. It prints on the plate, so recessed or inlaid only; mirrored to read correctly from below.
bottom_mode = "none"; // [none:None, engrave:Engrave (recessed), inlay:Inlay (flush, second colour)]
bottom_file = "examples/spool.svg";
// Artwork width (mm, 0 = 55% of the cup diameter)
bottom_width = 0; // [0:0.5:160]
// Artwork height (mm, 0 = keep proportions)
bottom_height = 0; // [0:0.5:160]
bottom_rotate = 0; // [0:1:359]
// Engrave / inlay depth (mm); the floor is thickened by this much
bottom_depth = 0.6; // [0.2:0.1:2]

/* [Hidden] */
PART_COLOR = "Tan";
ART_COLOR  = "white";
$fn = 180;
eps = 0.01;

// ---------------------------------------------------------------- derived
Rc   = cup_id / 2 + wall;           // cup wall outer radius
cup_od = 2 * Rc;
Ri   = Rc - wall;                   // cup inner radius
g    = fabric_t + rib_clear;        // radial gap between nested tooth surfaces
Rrec = Rc + g + rib_h;              // cover inner radius where it must clear cup ribs
Ro   = Rrec + cover_wall;           // cover / plinth outer radius
Rlip = Ri - lip_reach;              // lip inner radius
bottom_on = bottom_mode != "none";
floor_eff = floor_t + (bottom_on ? bottom_depth : 0);   // floor including art depth

ramp_len = rib_h / tan(lead_angle);   // vertical extent of the lead-in ramp
ret_len  = rib_h * tan(ret_angle);    // vertical extent of the retention face
assert(ramp_len + ret_len <= rib_pitch + eps,
       str("rib_pitch too small: need at least ", ramp_len + ret_len));

z_rib_top = cup_h - rim_round_o - rim_land;          // top of first rib (cup coords)
z_rib_bot = z_rib_top - rib_rows * rib_pitch;
z_cov_bot = z_rib_bot - skirt_extra;                 // cover bottom edge, seated
z_plinth  = z_cov_bot - reveal;                      // top of cup plinth
z_lip_bot = cup_h + fabric_t;                        // lip underside, seated
z_cov_top = z_lip_bot + lip_t;
cover_h   = z_cov_top - z_cov_bot;
assert(z_plinth >= floor_eff + 1, "cup_h too small for the rib rows and skirt; raise cup_h or reduce rib_rows");
assert(wall - rim_round_o - rim_round_i >= 0.2, "rim roundings too large for the wall thickness");
assert(g < rib_h, "fabric_t + rib_clear must be less than rib_h or the teeth will not interlock");

engage   = rib_h - g;               // radial overlap of nested teeth (retention)
pass_exp = rib_h - rib_clear;       // radial stretch needed to pass with fabric in place

// ------------------------------------------------- sawtooth (cup coordinates)
// Outward offset of the cup surface at height z within the rib band.
// Each tooth, top to bottom: lead-in ramp (radius grows), retention face
// (radius shrinks), then a flat land.
function tooth(z) =
    let(d = z_rib_top - z)
    (d < 0 || d > rib_rows * rib_pitch) ? 0 :
    let(k = floor(d / rib_pitch), u = d - k * rib_pitch)
    u < ramp_len            ? rib_h * u / ramp_len :
    u < ramp_len + ret_len  ? rib_h * (1 - (u - ramp_len) / ret_len) :
    0;

// Profile points for the rib band, listed from top to bottom, as [r, z].
function rib_band(base_r) =
    [ for (k = [0 : rib_rows - 1])
        let(zt = z_rib_top - k * rib_pitch)
        each [ [base_r,          zt],
               [base_r + rib_h,  zt - ramp_len],
               [base_r,          zt - ramp_len - ret_len] ] ];

function arc(c, r, a0, a1, n = 16) =
    [ for (i = [0 : n]) let(a = a0 + (a1 - a0) * i / n) c + r * [cos(a), sin(a)] ];

// ---------------------------------------------------------------- cup
module cup_profile() {
    pts = concat(
        [[0, 0], [Ro - chamfer, 0], [Ro, chamfer],
         [Ro, z_plinth - chamfer], [Ro - chamfer, z_plinth],
         [Rc, z_plinth]],
        // up the wall: rib band reversed (bottom to top)
        [ for (i = [len(rib_band(Rc)) - 1 : -1 : 0]) rib_band(Rc)[i] ],
        arc([Rc - rim_round_o, cup_h - rim_round_o], rim_round_o, 0, 90),
        arc([Ri + rim_round_i, cup_h - rim_round_i], rim_round_i, 90, 180),
        floor_round > 0
            ? concat(arc([Ri - floor_round, floor_eff + floor_round], floor_round, 0, -90, 8),
                     [[0, floor_eff]])
            : [[Ri, floor_eff], [0, floor_eff]]
    );
    polygon(pts);
}

module cup_body() { rotate_extrude() cup_profile(); }

module svg_art(file, w, h, rot, mir = false) {
    rotate(rot) mirror([mir ? 1 : 0, 0, 0])
        resize([w, h], auto = true) import(file, center = true);
}
module bottom_svg_2d() {
    svg_art(bottom_file, bottom_width > 0 ? bottom_width : 0.55 * cup_od,
            bottom_height, bottom_rotate, true);     // mirrored: read from underneath
}

module cup() {
    difference() {
        cup_body();
        if (bottom_on) translate([0, 0, -1]) linear_extrude(bottom_depth + 1) bottom_svg_2d();
    }
}
module cup_art() {
    if (bottom_mode == "inlay") linear_extrude(bottom_depth) bottom_svg_2d();
}

// ---------------------------------------------------------------- cover
// Modelled in cup coordinates, in its seated position.
module cover_profile() {
    c2 = lip_t / 2;
    outer = [
        [Rrec + chamfer, z_cov_bot],            // inner bottom lead-in chamfer
        [Ro - chamfer, z_cov_bot],
        [Ro, z_cov_bot + chamfer],
        [Ro, z_cov_top - chamfer * 1.5],
        [Ro - chamfer * 1.5, z_cov_top],
        [Rlip + c2, z_cov_top],                 // top face of lip
        [Rlip + c2 - c2 * 0.0, z_cov_top]
    ];
    // inner lip edge: 45 deg chamfer on top (prints on the plate), round below
    lip_edge = concat(
        [[Rlip + c2 * 0.5, z_cov_top]],
        [[Rlip, z_cov_top - c2 * 0.5]],
        arc([Rlip + c2, z_lip_bot + c2], c2, 180, 270, 8)
    );
    // underside of lip, then the corner that follows the cup rim rounding
    under = concat(
        [[Rc - rim_round_o, z_lip_bot]],
        arc([Rc - rim_round_o, cup_h - rim_round_o], rim_round_o + g, 90, 0, 12)
    );
    band = rib_band(Rc + g);
    pts = concat(
        [outer[0], outer[1], outer[2], outer[3], outer[4]],
        lip_edge,
        under,
        band,
        [[Rrec, z_rib_bot - rib_h], [Rrec, z_cov_bot + chamfer]]
    );
    polygon(pts);
}

module cover_body() { rotate_extrude() cover_profile(); }

// ---- cover side artwork: wrapped onto the cylinder from narrow flat strips
band_lo  = z_cov_bot + chamfer;            // plain outer band on the cover
band_hi  = z_cov_top - chamfer * 1.5;
band_h   = band_hi - band_lo;
band_mid = (band_lo + band_hi) / 2;

module side_svg_2d(file, w, h, rot) {
    hh = h > 0 ? h : 0.6 * band_h;
    rotate(rot) resize([w, hh], auto = true) import(file, center = true);
}

// One location: 2D art (x along the curve, y up) wrapped around radius R,
// solid from R - d_in to R + d_out, centred at angle ang and height zc.
module wrapped(file, w, h, rot, ang, zc, R, d_in, d_out) {
    hh = h > 0 ? h : 0.6 * band_h;
    half = w > 0 ? w / 2 + 1 : min(PI * R * 0.45, 3 * hh);   // strip range to cover
    n = ceil(2 * half / side_strip);
    rotate([0, 0, ang])
    for (i = [0 : n - 1]) {
        x0 = -half + i * side_strip;
        xc = x0 + side_strip / 2;
        rotate([0, 0, xc / R * 180 / PI])
        translate([R - d_in, 0, zc]) rotate([90, 0, 90])
            linear_extrude(d_in + d_out)
            translate([-xc, 0])
            intersection() {
                side_svg_2d(file, w, h, rot);
                // overlap neighbours slightly so the strips fuse with no slits
                translate([x0 - 0.05, -100]) square([side_strip + 0.1, 200]);
            }
    }
}

function side_on(m) = m != "none";
module side_loc(k, d_in, d_out) {
    if (k == 1)
        wrapped(side1_file, side1_width, side1_height, side1_rotate, side1_angle,
                band_mid + side1_z_shift, Ro, d_in, d_out);
    else
        wrapped(side2_file, side2_width, side2_height, side2_rotate, side2_angle,
                band_mid + side2_z_shift, Ro, d_in, d_out);
}
function side_mode(k) = k == 1 ? side1_mode : side2_mode;

assert(side_depth <= cover_wall - 1.0, "side_depth too deep for cover_wall");

// Cover with engraved / inlay recesses, seated position (cup coordinates)
module cover_seated() {
    difference() {
        cover_body();
        for (k = [1, 2]) if (side_mode(k) == "engrave" || side_mode(k) == "inlay")
            side_loc(k, side_depth, 1);
    }
}
// Artwork solids, seated position: inlays trimmed flush, raised art sits proud
module cover_art_seated() {
    for (k = [1, 2]) {
        if (side_mode(k) == "inlay")
            intersection() { side_loc(k, side_depth, 1); cover_body(); }
        if (side_mode(k) == "raise")
            side_loc(k, 0.2, side_depth);
    }
}

// Flipped for printing: lip on the plate (rotated, not mirrored, so art reads right).
module cover_print_xform() { translate([0, 0, z_cov_top]) rotate([180, 0, 0]) children(); }
module cover_print()     { cover_print_xform() cover_seated(); }
module cover_art_print() { cover_print_xform() cover_art_seated(); }

// ---------------------------------------------------------------- fabric pattern
rho     = dome_h > 0 ? (Ri * Ri + dome_h * dome_h) / (2 * dome_h) : 1e9;
dome_a  = dome_h > 0 ? rho * 2 * atan(dome_h / Ri) * PI / 180 : Ri;    // arc, apex to rim edge
// arc length from apex out to radius r on the dome
function dome_s(r) = dome_h > 0 ? rho * asin(min(1, r / rho)) * PI / 180 : r;
taut    = 1 - taut_pct / 100;
a_in    = dome_s(Ri) * taut;                                  // ~ dome_a * taut
// fabric path over the rim top and around the outer rounding
rim_path = (wall - rim_round_o - rim_round_i)
         + rim_round_i * PI / 2 * 0.5
         + rim_round_o * PI / 2;
r1      = a_in + rim_path + fabric_t;                         // start of the side wall
tab_len = (cup_h - rim_round_o) - (z_cov_bot + tab_margin);
r_out   = r1 + tab_len;
// notch apex: hidden under the lip, halfway between lip edge and inner wall
r_v     = dome_s(Ri - lip_reach / 2) * taut;
w_tab   = 2 * PI * Rc * tab_fill / tabs;
alpha   = 180 / tabs;

module notch() {
    s  = sqrt(r1 * r1 - w_tab * w_tab / 4);
    far = r_out * 2;
    rot = function(p, a) [p[0] * cos(a) - p[1] * sin(a), p[0] * sin(a) + p[1] * cos(a)];
    A  = rot([s, -w_tab / 2], alpha);
    Af = rot([far, -w_tab / 2], alpha);
    B  = rot([s,  w_tab / 2], -alpha);
    Bf = rot([far,  w_tab / 2], -alpha);
    polygon([[r_v, 0], A, Af, Bf, B]);
}

module pattern() {
    offset(r = tab_round) offset(delta = -tab_round)
    difference() {
        circle(r = r_out);
        for (k = [0 : tabs - 1]) rotate((k + 0.5) * 360 / tabs) notch();
    }
}

// ---------------------------------------------------------------- report
echo(str("Cover art band: ", band_h, " mm tall (default art height ", 0.6 * band_h, " mm); circumference ", 2 * PI * Ro, " mm"));
if (side1_mode == "raise" || side2_mode == "raise")
    echo("NOTE: raised cover art: the bottom edges of the raised shapes print as small overhangs.");
if (side1_mode == "inlay" || side2_mode == "inlay")
    echo("NOTE: inlay on the cover wall needs a filament change on every layer the art spans.");
// washer weight report
w_need  = washers_per_layer == 7 ? 3 * washer_od : washer_od;
w_mass  = 7.85e-3 * PI / 4 * (washer_od * washer_od - washer_id * washer_id) * washer_t;   // g, steel
if (washer_layers > 0) {
    echo(str("Washers: ", washers_per_layer, " per layer need ", w_need, " mm across; cup ID ", cup_id,
             " leaves ", cup_id - w_need, " mm. ", washer_layers, " layer(s) = ",
             washer_layers * washers_per_layer, " washers, ~", round(washer_layers * washers_per_layer * w_mass),
             " g; stack ", washer_layers * washer_t, " mm, leaving ",
             cup_h - floor_eff - washer_layers * washer_t, " mm of cup depth for batting"));
    if (cup_id < w_need + 0.5)
        echo("WARNING: cup_id is too small for this washer layout (allow at least 0.5 mm clearance)");
}
echo(str("Cup: OD ", 2 * Ro, " mm overall (plinth), wall OD ", cup_od, ", ID ", 2 * Ri, ", height ", cup_h));
echo(str("Cover: OD ", 2 * Ro, ", height ", cover_h, ", lip opening ", 2 * Rlip));
echo(str("Ribs: engagement ", engage, " mm radial; hoop stretch to pass ", pass_exp,
         " mm = ", 100 * pass_exp / Rrec, "% strain"));
echo(str("Pattern: diameter ", 2 * r_out, " mm, ", tabs, " tabs ", w_tab, " mm wide x ", tab_len, " mm long"));
echo(str("Dome: arc ", dome_a, " mm over ", Ri, " mm radius -> ",
         100 * (dome_a / Ri - 1), "% excess circumference at the rim (absorbed by bias stretch / under the lip)"));

// ---------------------------------------------------------------- dispatch
module fabric_ghost() {
    // rough visualization of fabric over the batting dome
    color("indianred", 0.85)
    intersection() {
        translate([0, 0, cup_h - rho + dome_h]) sphere(r = rho, $fn = 120);
        translate([0, 0, cup_h]) cylinder(r = Ri, h = dome_h + 1);
    }
}

if (part == "cup") { color(PART_COLOR) cup(); color(ART_COLOR) cup_art(); }
else if (part == "cover") { color(PART_COLOR) cover_print(); color(ART_COLOR) cover_art_print(); }
else if (part == "cup_only") cup();
else if (part == "cover_only") cover_print();
else if (part == "cup_art") cup_art();
else if (part == "cover_art") cover_art_print();
else if (part == "pattern") pattern();
else if (part == "print_plate") {
    color(PART_COLOR) cup(); color(ART_COLOR) cup_art();
    translate([2 * Ro + 8, 0, 0]) { color(PART_COLOR) cover_print(); color(ART_COLOR) cover_art_print(); }
}
else if (part == "section") {
    // 2D half cross-section, seated, for checking fits
    color("ivory") cup_profile();
    color("steelblue") cover_profile();
}
else if (part == "assembly") {
    color("ivory") cup(); color(ART_COLOR) cup_art();
    translate([0, 0, explode]) { color("steelblue") cover_seated(); color(ART_COLOR) cover_art_seated(); }
    if (dome_h > 0) fabric_ghost();
}
else if (part == "cutaway") {
    difference() {
        union() {
            color("ivory") cup(); color(ART_COLOR) cup_art();
            translate([0, 0, explode]) { color("steelblue") cover_seated(); color(ART_COLOR) cover_art_seated(); }
            if (dome_h > 0) fabric_ghost();
        }
        translate([0, -200, -1]) cube([400, 400, 400]);
    }
}
