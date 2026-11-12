// =====================================================================
//  Pattern Weights — washer-stack pattern weights with threaded lids,
//  plus a storage box with a hinged, snap-latched lid.
//
//  Written by Claude (Anthropic) at the direction of Bob Drzyzgula,
//  replacing his earlier MakerWorld-generated "full set".
//  Version 1.4.1 (internal values kept out of Customizer presets)
//  License: MIT
//
//  Requires BOSL2 (https://github.com/BelfrySCAD/BOSL2) on the
//  OpenSCAD library path.
//
//  Each weight is a cup that holds a stack of flat steel washers.
//  The lid screws down until its underside bears on the top washer,
//  so the stack is always clamped tight. A plain (unthreaded) skirt
//  below the lid's threads hides any exposed thread, so a thick
//  stack never looks like an unclosed lid; only the width of the
//  reveal groove (flush style) or the lid's height on the body
//  (overcap style) changes, by at most the thickness tolerance.
//
//  The console reports dimensions and approximate masses.
// =====================================================================

include <BOSL2/std.scad>
include <BOSL2/threading.scad>

/* [What to render] */
part = "weight"; // [weight:Weight - body and lid, body:Weight body, lid:Weight lid, lid_only:Weight lid without artwork solid, inlay:Artwork solid only (inlay or raised), box_set:Storage box and lid, box:Storage box, box_lid:Storage box lid, box_only:Storage box without artwork solid, box_lid_only:Storage box lid without artwork solid, box_inlays:Box artwork solids only, weight_cutaway:Preview - weight cutaway with washers, box_cutaway:Preview - box with weights (cutaway)]

/* [Washers] */
washer = "uss_3_4"; // [uss_1_4:USS 1/4 (0.734 OD), uss_5_16:USS 5/16 (0.875 OD), uss_3_8:USS 3/8 (1.000 OD), uss_1_2:USS 1/2 (1.375 OD), uss_5_8:USS 5/8 (1.750 OD), uss_3_4:USS 3/4 (2.000 OD), uss_7_8:USS 7/8 (2.250 OD), uss_1:USS 1 (2.500 OD), uss_1_1_4:USS 1-1/4 (3.000 OD), uss_1_1_2:USS 1-1/2 (3.500 OD), uss_1_3_4:USS 1-3/4 (4.000 OD), sae_3_8:SAE 3/8 (0.812 OD), sae_1_2:SAE 1/2 (1.062 OD), sae_5_8:SAE 5/8 (1.312 OD), sae_3_4:SAE 3/4 (1.469 OD), sae_7_8:SAE 7/8 (1.750 OD), sae_1:SAE 1 (2.000 OD), sae_1_1_4:SAE 1-1/4 (2.500 OD), sae_1_1_2:SAE 1-1/2 (3.000 OD), iso7089_m10:ISO 7089 M10 (20 OD), iso7089_m12:ISO 7089 M12 (24 OD), iso7089_m16:ISO 7089 M16 (30 OD), iso7089_m20:ISO 7089 M20 (37 OD), iso7089_m24:ISO 7089 M24 (44 OD), iso7089_m30:ISO 7089 M30 (56 OD), iso7089_m36:ISO 7089 M36 (66 OD), iso7089_m42:ISO 7089 M42 (78 OD), iso7093_m8:ISO 7093 large M8 (24 OD), iso7093_m10:ISO 7093 large M10 (30 OD), iso7093_m12:ISO 7093 large M12 (37 OD), iso7093_m16:ISO 7093 large M16 (50 OD), iso7093_m20:ISO 7093 large M20 (60 OD), iso7093_m24:ISO 7093 large M24 (72 OD), iso7093_m30:ISO 7093 large M30 (92 OD), custom:Custom (enter below)]
// Washers per weight
washer_count = 4; // [1:1:30]
// Custom washer outside diameter (mm)
custom_od = 50.8; // [15:0.1:110]
// Custom washer hole diameter (mm)
custom_id = 20.6; // [0:0.1:60]
// Custom nominal thickness (mm)
custom_thickness = 3.76; // [0.5:0.01:10]
// Custom minimum thickness (mm)
custom_thickness_min = 3.10; // [0.5:0.01:10]
// Custom maximum thickness (mm)
custom_thickness_max = 4.50; // [0.5:0.01:10]
// How much stack-height variation the lid must absorb
stack_tolerance = "spec"; // [spec:Full standard min-max thickness, percent:Plus-minus percent of nominal, mm:Explicit mm below]
// Used when stack_tolerance = percent
tolerance_percent = 12; // [1:1:40]
// Used when stack_tolerance = mm: stack may be this much thinner than nominal
tolerance_under_mm = 1.5; // [0:0.1:15]
// Used when stack_tolerance = mm: stack may be this much thicker than nominal
tolerance_over_mm = 2.0; // [0:0.1:15]
// Diametral clearance between washer OD and the bore (mm)
bore_clearance = 0.8; // [0.2:0.1:3]

/* [Felt pad and base] */
felt_pad = "auto_in"; // [auto_in:Auto - largest inch pad that fits, auto_mm:Auto - largest metric pad that fits, in_0.75:3/4 in, in_1:1 in, in_1.5:1-1/2 in, in_2:2 in, in_3:3 in, in_4:4 in, mm_20:20 mm, mm_25:25 mm, mm_30:30 mm, mm_40:40 mm, mm_50:50 mm, mm_60:60 mm, mm_80:80 mm, mm_100:100 mm, custom:Custom (enter below), none:No pad]
// Custom pad diameter (mm)
custom_pad_d = 38.1; // [10:0.1:120]
// Footprint extends this far beyond the pad edge (mm)
pad_margin = 1.5; // [0:0.1:5]
// Minimum inset from body wall to footprint (mm)
min_base_inset = 1.5; // [0.5:0.1:10]
// Shape of the taper from body down to the pad footprint (all print without supports)
base_profile = "chamfer"; // [chamfer:45 degree chamfer, round:Rounded (convex), cove:Coved (concave)]
// Radius of the round/cove curve (mm)
base_curve_r = 8; // [1:0.5:30]
// Optional shallow pocket to locate the pad (mm, 0 = flat)
pad_recess = 0; // [0:0.1:1.5]

/* [Weight body and lid] */
// flush = lid OD matches body with a reveal groove; overcap = lid caps over a plain body
weight_style = "flush"; // [flush:Flush lid with reveal groove, overcap:Overcap lid]
// 0 = automatic from carried mass
wall_override = 0; // [0:0.1:6]
// 0 = automatic from diameter
thread_pitch_override = 0; // [0:0.25:6]
// Thread starts (2 = half the turns to close)
thread_starts = 2; // [1:1:3]
// Thread clearance (BOSL2 $slop)
thread_slop = 0.15; // [0:0.01:0.5]
// Narrowest reveal groove when the stack is at its thinnest (flush style, mm)
min_reveal = 1.5; // [0.5:0.1:5]
// Grip flutes around the lid skirt
lid_flutes = true;

/* [Lid artwork (SVG)] */
svg_mode = "none"; // [none:None, engrave:Engrave (recessed), inlay:Inlay (flush, second colour), raise:Raised (lid then prints upright - needs supports)]
svg_file = "examples/spool.svg";
// Artwork width on the lid (mm, 0 = 55% of lid diameter)
svg_width = 0; // [0:0.5:150]
// Artwork height (mm, 0 = keep proportions)
svg_height = 0; // [0:0.5:150]
// Engrave / inlay depth or raised height (mm)
svg_depth = 0.6; // [0.2:0.1:3]
svg_rotate = 0; // [0:1:359]
svg_mirror = false;

/* [Storage box] */
// Weights stacked in the box
box_count = 4; // [1:1:12]
// Radial clearance around each weight (mm)
box_clearance = 1.0; // [0.3:0.1:5]
// Extra headroom above the stack (mm)
box_headroom = 1.5; // [0:0.5:20]
// Outer corner radius as a fraction of the box width
box_corner_fraction = 0.33; // [0.05:0.01:0.49]
// 0 = automatic from total set mass
box_wall_override = 0; // [0:0.1:5]
// Hinge pin hole diameter in the box (2.0 suits a length of 1.75 filament; 3.2 suits an M3 screw or 1/8 rod)
hinge_pin_hole = 2.0; // [1.5:0.05:4]
// Extra diameter for the lid's pin holes, which print sideways and face-down
lid_pin_extra = 0.15; // [0:0.05:0.6]
// Opening angle for the box cutaway preview
preview_lid_angle = 0; // [0:5:180]

/* [Box artwork (SVG)] */
// Artwork on top of the box lid (it prints face-down, so recessed or inlaid only)
box_lid_svg_mode = "none"; // [none:None, engrave:Engrave (recessed), inlay:Inlay (flush, second colour)]
box_lid_svg_file = "examples/spool.svg";
// Width on the box lid (mm, 0 = 55% of box width)
box_lid_svg_width = 0; // [0:0.5:200]
// Height (mm, 0 = keep proportions)
box_lid_svg_height = 0; // [0:0.5:200]
box_lid_svg_rotate = 0; // [0:1:359]
// Artwork under the box (it prints on the bed, so recessed or inlaid only; mirrored to read correctly from below)
box_bottom_svg_mode = "none"; // [none:None, engrave:Engrave (recessed), inlay:Inlay (flush, second colour)]
box_bottom_svg_file = "examples/spool.svg";
// Width under the box (mm, 0 = 55% of box width)
box_bottom_svg_width = 0; // [0:0.5:200]
// Height (mm, 0 = keep proportions)
box_bottom_svg_height = 0; // [0:0.5:200]
box_bottom_svg_rotate = 0; // [0:1:359]
// Engrave / inlay depth for box artwork (mm)
box_svg_depth = 0.6; // [0.2:0.1:2]

/* [Latch] */
// 0 = automatic (12 mm, narrower on small boxes)
latch_width_override = 0; // [0:0.5:25]
latch_thickness = 1.6; // [1:0.1:3]
// Flexing length from lid to catch (mm)
latch_length = 14; // [8:0.5:25]
// Depth of the hook (mm)
latch_hook = 1.8; // [0.8:0.1:2.5]
// Back-tilt of the hook's catching face (load pulls the hook in, not out)
latch_angle = 10; // [0:1:20]

/* [Material and resolution] */
steel_density = 7.85; // [7:0.01:8.5]
// PETG 1.27, PLA 1.24 (g/cm3)
plastic_density = 1.27; // [0.9:0.01:2]
$fa = 2;
$fs = 0.4;

/* [Hidden] */
// Internal values below are written as expressions ("0 + x") so the
// Customizer doesn't list them and saved presets can't capture them;
// otherwise an old preset would override them in later versions.
eps = 0 + 0.01;

// ---------------------------------------------------------------------
//  Data tables
// ---------------------------------------------------------------------
function in2mm(x) = x * 25.4;
// ASME B18.22.1 Type A thickness classes [nom, min, max] (inch)
T065 = [.065, .051, .080];  T083 = [.083, .064, .104];
T095 = [.095, .074, .121];  T109 = [.109, .086, .132];
T134 = [.134, .108, .160];  T148 = [.148, .122, .177];
T165 = [.165, .136, .192];  T180 = [.180, .153, .213];
function iw(key, od, id, t) = [key, in2mm(od), in2mm(id), in2mm(t[0]), in2mm(t[1]), in2mm(t[2])];
// [key, OD, ID, t_nom, t_min, t_max] in mm
WASHERS = [
    iw("uss_1_4",   0.734, 0.312, T065), iw("uss_5_16",  0.875, 0.375, T083),
    iw("uss_3_8",   1.000, 0.438, T083), iw("uss_1_2",   1.375, 0.562, T109),
    iw("uss_5_8",   1.750, 0.688, T134), iw("uss_3_4",   2.000, 0.812, T148),
    iw("uss_7_8",   2.250, 0.938, T165), iw("uss_1",     2.500, 1.062, T165),
    iw("uss_1_1_4", 3.000, 1.375, T165), iw("uss_1_1_2", 3.500, 1.625, T180),
    iw("uss_1_3_4", 4.000, 1.875, T180),
    iw("sae_3_8",   0.812, 0.406, T065), iw("sae_1_2",   1.062, 0.531, T095),
    iw("sae_5_8",   1.312, 0.656, T095), iw("sae_3_4",   1.469, 0.812, T134),
    iw("sae_7_8",   1.750, 0.938, T134), iw("sae_1",     2.000, 1.062, T134),
    iw("sae_1_1_4", 2.500, 1.375, T165), iw("sae_1_1_2", 3.000, 1.625, T165),
    // ISO 7089 normal series
    ["iso7089_m10", 20, 10.5, 2,   1.8, 2.2], ["iso7089_m12", 24, 13, 2.5, 2.3, 2.7],
    ["iso7089_m16", 30, 17,   3,   2.7, 3.3], ["iso7089_m20", 37, 21, 3,   2.7, 3.3],
    ["iso7089_m24", 44, 25,   4,   3.7, 4.3], ["iso7089_m30", 56, 31, 4,   3.7, 4.3],
    ["iso7089_m36", 66, 37,   5,   4.4, 5.6], ["iso7089_m42", 78, 45, 8,   7.0, 9.0],
    // ISO 7093-1 large series
    ["iso7093_m8",  24, 8.4,  2,   1.8, 2.2], ["iso7093_m10", 30, 10.5, 2.5, 2.3, 2.7],
    ["iso7093_m12", 37, 13,   3,   2.7, 3.3], ["iso7093_m16", 50, 17,   3,   2.7, 3.3],
    ["iso7093_m20", 60, 22,   4,   3.7, 4.3], ["iso7093_m24", 72, 26,   5,   4.4, 5.6],
    ["iso7093_m30", 92, 33,   6,   5.4, 6.6],
    ["custom", custom_od, custom_id, custom_thickness, custom_thickness_min, custom_thickness_max]
];
PADS_IN = [0.75, 1, 1.5, 2, 3, 4] * 25.4;
PADS_MM = [20, 25, 30, 40, 50, 60, 80, 100];

W_ROW = WASHERS[search([washer], WASHERS)[0]];
w_od = W_ROW[1];  w_id = W_ROW[2];
w_t = W_ROW[3];   w_tmin = W_ROW[4];  w_tmax = W_ROW[5];
n = washer_count;

// ---------------------------------------------------------------------
//  Derived weight dimensions (all mm)
// ---------------------------------------------------------------------
function rnd(x, q=0.1) = round(x / q) * q;
function clamp(x, lo, hi) = min(hi, max(lo, x));

washer_mass = steel_density * PI / 4 * (w_od*w_od - w_id*w_id) * w_t / 1000;  // g
stack_mass  = n * washer_mass;

S_nom = n * w_t;
S_min = stack_tolerance == "spec"    ? n * w_tmin
      : stack_tolerance == "percent" ? S_nom * (1 - tolerance_percent/100)
      :                                max(0.5, S_nom - tolerance_under_mm);
S_max = stack_tolerance == "spec"    ? n * w_tmax
      : stack_tolerance == "percent" ? S_nom * (1 + tolerance_percent/100)
      :                                S_nom + tolerance_over_mm;
S_range = S_max - S_min;

// Wall sized from carried mass: ~2.0 mm for <100 g, ~2.5 at 250 g, ~3 at 1 kg
wall = wall_override > 0 ? wall_override
     : rnd(clamp(1.6 + 0.6 * pow(stack_mass / 100, 1/3), 2.0, 4.0));
floor_min = wall + 0.4;

d_bore = w_od + bore_clearance;
pitch  = thread_pitch_override > 0 ? thread_pitch_override
       : d_bore < 30 ? 2 : d_bore < 65 ? 2.5 : d_bore < 95 ? 3 : 3.5;
t_depth = rnd(0.30 * pitch, 0.05);         // 90-degree (45-degree flank) thread
engage  = max(2.5 * pitch, 6);             // minimum axial thread engagement
D_root  = d_bore + 2 * wall;               // neck diameter at thread root
D_major = D_root + 2 * t_depth;            // thread major diameter
skirt_plain_gap = 0 + 0.4; // radial gap, plain skirt over threads/body
D_lid   = D_major + 2 * wall + 0.4;        // lid outside diameter
D_body  = weight_style == "flush" ? D_lid : D_major + 0.4;   // overcap: 0.2 proud of the thread crests

top_base  = max(2.4, wall);
top_thick = top_base + ((svg_mode == "engrave" || svg_mode == "inlay") ? svg_depth : 0);
raise_h   = svg_mode == "raise" ? svg_depth : 0;

L_thread = S_range + 0.5 + engage;         // lid thread zone length
L_plain  = S_range + 0.5;                  // plain skirt hiding exposed thread

// --- felt pad selection ---
foot_max = D_body - 2 * min_base_inset;
function largest_fit(list, lim, i=0, best=-1) =
    i >= len(list) ? best
    : largest_fit(list, lim, i+1, list[i] + 2*pad_margin <= lim ? list[i] : best);
pad_d = felt_pad == "none"    ? 0
      : felt_pad == "custom"  ? custom_pad_d
      : felt_pad == "auto_in" ? max(0, largest_fit(PADS_IN, foot_max))
      : felt_pad == "auto_mm" ? max(0, largest_fit(PADS_MM, foot_max))
      : felt_pad[0] == "i" ? in2mm(parse_num(substr(felt_pad, 3)))
      : parse_num(substr(felt_pad, 3));
D_foot = pad_d > 0 ? min(D_body - 2*0.5, pad_d + 2 * pad_margin) : D_body - 2;
R_body = D_body / 2;
r_foot = D_foot / 2;
dr = R_body - r_foot;

// --- base taper profile, as [r, z] points from footprint up to full radius ---
k45 = 1 - cos(45);  // 0.2929
Rc = min(base_curve_r, dr / k45);
function arc_pts(c, R, a0, a1, steps=12) = [for (i=[0:steps]) let(a=a0+(a1-a0)*i/steps) c + R*[cos(a), sin(a)]];
taper_pts =
    base_profile == "chamfer" ? [[r_foot, 0], [R_body, dr]]
  : base_profile == "round"   ?
        let(a = k45*Rc, b = sin(45)*Rc, zc = dr - a + b)
        concat([[r_foot, 0]], arc_pts([R_body - Rc, zc], Rc, -45, 0))
  : /* cove */
        let(a = k45*Rc, b = sin(45)*Rc)
        concat(arc_pts([r_foot + Rc, 0], Rc, 180, 135), [[R_body, b + dr - a]]);
taper_h = taper_pts[len(taper_pts)-1][1];

// lowest height at which the taper is far enough out to leave a full wall around the bore
function r_at(z, pts, i=0) =
    i >= len(pts)-1 ? pts[len(pts)-1][0]
  : z <= pts[i+1][1] ? pts[i][0] + (pts[i+1][0]-pts[i][0]) * (z - pts[i][1]) / max(eps, pts[i+1][1]-pts[i][1])
  : r_at(z, pts, i+1);
function first_z(target, pts, z=0) = z >= taper_h || r_at(z, pts) >= target ? z : first_z(target, pts, z + 0.1);
floor_taper = first_z(d_bore/2 + wall, taper_pts);
floor0 = max(floor_min, floor_taper) + pad_recess;

// --- vertical layout ---
// Lid local z: 0 = surface that bears on the washers; plug occupies 0..P.
// Body rim sits 0.5 below the lid ceiling when the stack is at its thinnest.
z_rim_req = taper_h + 1.5 + (weight_style == "flush" ? min_reveal : 0) + L_thread + L_plain - 0.5;
P0 = max(0, z_rim_req - (floor0 + S_min - 0.5));
f_thick = (P0 > 0 && P0 < 1.2) ? floor0 + P0 : floor0;
P       = (P0 > 0 && P0 < 1.2) ? 0 : P0;
z_rim   = f_thick + S_min + P - 0.5;
z_tb    = z_rim - L_thread;                         // bottom of body thread
z_low   = z_rim + 0.5 - L_thread - L_plain;          // lowest the lid skirt reaches
z_shoulder = weight_style == "flush" ? z_low - min_reveal : z_tb;
lid_h   = L_thread + L_plain + top_thick;
H_nom   = f_thick + S_nom + P + top_thick + raise_h;
H_max   = f_thick + S_max + P + top_thick + raise_h;
H_min   = f_thick + S_min + P + top_thick + raise_h;
plug_od = d_bore - 1.0;
plug_id = max(w_id + 2, plug_od - 2 * max(3, wall + 1));

// --- approximate plastic volume (mm^3) ---
function cylv(d, h) = PI * d * d / 4 * h;
function frust(r1, r2, h) = PI * h / 3 * (r1*r1 + r1*r2 + r2*r2);
v_body = frust(r_foot, R_body, taper_h) + cylv(D_body, z_shoulder - taper_h)
       + cylv(D_root, z_rim - z_shoulder) + PI * D_root * t_depth * 0.5 * L_thread
       - cylv(d_bore, z_rim - f_thick);
v_lid  = cylv(D_lid, lid_h) - cylv(D_root + t_depth, L_thread) - cylv(D_major + 2*skirt_plain_gap, L_plain)
       + (P > 0 ? cylv(plug_od, P) - cylv(plug_id, P) : 0);
plastic_mass = (v_body + v_lid) * plastic_density / 1000;
weight_mass = stack_mass + plastic_mass;

// ---------------------------------------------------------------------
//  Storage box dimensions
// ---------------------------------------------------------------------
set_mass  = box_count * weight_mass;
box_wall  = box_wall_override > 0 ? box_wall_override
          : rnd(clamp(1.4 + 0.4 * pow(set_mass / 100, 1/3), 2.0, 3.2));
box_lid_art_on    = box_lid_svg_mode != "none";
box_bottom_art_on = box_bottom_svg_mode != "none";
box_floor = box_wall + 0.4 + (box_bottom_art_on ? box_svg_depth : 0);
B_in   = D_lid + 2 * box_clearance;
B_out  = B_in + 2 * box_wall;
r_out  = box_corner_fraction * B_out;
r_in   = max(0.5, r_out - box_wall);
box_H  = box_floor + box_count * H_max + box_headroom;   // rim height
lid_t  = max(2.4, box_wall + 0.4) + (box_lid_art_on ? box_svg_depth : 0);   // box lid plate thickness
lip_h  = 0 + 3; lip_t = 0 + 1.6; lip_gap = 0 + 0.3;
// hinge
kr      = max(3.2, hinge_pin_hole/2 + 2.0);               // knuckle radius
k_gap   = 0 + 0.4;
hinge_y = B_out/2 + kr + k_gap;
knuckle_flat = 0 + 0.3; // knuckle tops cut flat, flush with lid top
hinge_z = box_H + lid_t - kr + knuckle_flat;
flat_len = B_out - 2 * r_out;
// 0.9137: keeps the knuckle ends off the corner curve's facet vertices (a
// knuckle end through a vertex leaves a non-manifold edge)
hinge_len = min(B_out - 2*box_wall - 4, flat_len + 0.9137 * r_out);
n_knuckles = hinge_len >= 45 ? 5 : 3;
k_len = (hinge_len - (n_knuckles - 1) * k_gap) / n_knuckles;
// latch
latch_width = latch_width_override > 0 ? latch_width_override : rnd(min(12, 0.3 * B_out), 0.5);
l_gap   = 0 + 0.4;
boss_p  = latch_thickness + l_gap + latch_hook + 1.2;     // boss protrusion
boss_w  = latch_width + 2 * (l_gap + 3);
z_catch = box_H - latch_length;
boss_len = latch_length + latch_hook + 3;                 // boss height below rim
tab_tip  = 0 + 3; // tab length below the boss

// ---------------------------------------------------------------------
//  Report
// ---------------------------------------------------------------------
function f1(x) = str(round(x * 10) / 10);
function f2(x) = str(round(x * 100) / 100);
function inch_s(x) = str(round(x / 25.4 * 1000) / 1000, " in");
echo(str("\n==== PATTERN WEIGHT REPORT ====",
  "\n Washer: ", washer, "  OD ", f2(w_od), "  ID ", f2(w_id), "  t ", f2(w_t), " (", f2(w_tmin), "-", f2(w_tmax), ") mm",
  "\n Stack of ", n, ": nominal ", f1(S_nom), " mm, accepted ", f1(S_min), " to ", f1(S_max), " mm",
  "\n Wall ", f1(wall), " mm, floor ", f1(f_thick), " mm, lid top ", f1(top_thick), " mm, lid plug ", f1(P), " mm",
  "\n Thread: ", f1(D_major), " mm major, pitch ", pitch, ", depth ", t_depth, ", ", thread_starts, " start(s), ", f1((L_thread - 0.5) / (pitch*thread_starts)), " turns to close on the thinnest stack",
  "\n Body OD ", f1(D_body), " (", inch_s(D_body), "), lid OD ", f1(D_lid), " (", inch_s(D_lid), ")",
  "\n Felt pad: ", pad_d > 0 ? str(f1(pad_d), " mm (", inch_s(pad_d), ")") : "none", ", footprint ", f1(D_foot), " mm",
  "\n Assembled height ", f1(H_min), " / ", f1(H_nom), " / ", f1(H_max), " mm (thin / nominal / thick stack)",
  "\n Mass: washers ", f1(washer_mass), " g each, stack ", f1(stack_mass), " g; plastic ~", f1(plastic_mass),
  " g (solid); WEIGHT ~", f1(weight_mass), " g (", f2(weight_mass/28.3495), " oz)",
  "\n Box: ", box_count, " weights, ", f1(B_out), " x ", f1(B_out), " x ", f1(box_H + lid_t), " mm closed, wall ", box_wall,
  "\n Set of ", box_count, " ~", f1(set_mass), " g (", f2(set_mass/453.592), " lb)",
  "\n================================"));
echo(str(" Lid top flat diameter ", f1(D_lid - 1.6), " mm (keep artwork inside this)"));
if (box_H + lid_t > 250)
    echo("NOTE: the storage box is taller than a 256 mm build volume allows; reduce box_count.");
if (svg_mode == "raise")
    echo("NOTE: raised artwork makes the lid print upright; enable supports for the lid's interior ceiling.");
if (pad_d > 0 && pad_d > D_body)
    echo("WARNING: chosen felt pad is wider than the body.");
assert(S_min > 0, "Stack minimum must be positive");
assert(w_id < w_od, "Washer ID must be less than OD");

// ---------------------------------------------------------------------
//  Weight geometry
// ---------------------------------------------------------------------
module body_profile_2d() {
    // flush: base ends at the reveal shoulder (chamfered); overcap: base runs
    // 0.5 up into the thread so the two never merely touch
    flush = weight_style == "flush";
    zt = z_shoulder;   // = z_tb for overcap
    ch = min(0.6, (z_shoulder - taper_h) / 2);
    polygon(concat(
        [[0, 0]],
        [[r_foot - 0.4, 0]],                 // tiny foot chamfer for elephant's foot
        [for (i=[0:len(taper_pts)-1]) i == 0 ? taper_pts[0] + [0, 0.4] : taper_pts[i]],
        flush ? [[R_body, zt - ch], [R_body - ch, zt]] : [[R_body, zt]],
        [[0, zt]]
    ));
}

module weight_body() {
    difference() {
        union() {
            rotate_extrude() body_profile_2d();
            if (weight_style == "flush")
                // slightly under the thread root, overlapping base and thread
                translate([0, 0, z_shoulder - 0.3]) cylinder(d = D_root - 0.4, h = z_tb - z_shoulder + 0.8);
            // thread starts 0.53 down inside the neck/base (not a fraction of the pitch,
            // so no ring of thread vertices lands on the base's top face)
            translate([0, 0, z_tb - 0.53])
                trapezoidal_threaded_rod(d = D_major, l = L_thread + 0.53, pitch = pitch, thread_angle = 90,
                    thread_depth = t_depth, starts = thread_starts, bevel1 = false, bevel2 = true,
                    anchor = BOTTOM);
        }
        // washer bore with a lead-in chamfer
        translate([0, 0, f_thick]) cylinder(d = d_bore, h = z_rim);
        translate([0, 0, z_rim - 0.8]) cylinder(d1 = d_bore, d2 = d_bore + 1.6 + eps, h = 0.8 + eps);
        if (pad_recess > 0 && pad_d > 0)
            translate([0, 0, -eps]) cylinder(d = pad_d + 0.6, h = pad_recess + eps);
    }
}

module svg_art(file, w, h, rot, mir = false) {
    rotate(rot) mirror([mir ? 1 : 0, 0, 0])
        resize([w, h], auto = true) import(file, center = true);
}
module svg_2d() {
    svg_art(svg_file, svg_width > 0 ? svg_width : 0.55 * D_lid, svg_height, svg_rotate, svg_mirror);
}
// box artwork, 2D, as seen from above (top) or from below (bottom)
module box_lid_svg_2d() {
    svg_art(box_lid_svg_file, box_lid_svg_width > 0 ? box_lid_svg_width : 0.55 * B_out,
            box_lid_svg_height, box_lid_svg_rotate);
}
module box_bottom_svg_2d() {
    svg_art(box_bottom_svg_file, box_bottom_svg_width > 0 ? box_bottom_svg_width : 0.55 * B_out,
            box_bottom_svg_height, box_bottom_svg_rotate, true);   // mirrored: read from underneath
}

// lid in USE orientation: z = 0 is the washer-bearing face
module weight_lid() {
    z0 = P - L_thread - L_plain;   // skirt bottom
    ztop = P + top_thick;
    nfl = floor(PI * D_lid / 5);
    difference() {
        union() {
            translate([0, 0, z0])
                cyl(d = D_lid, h = lid_h, chamfer1 = 0.6, chamfer2 = 0.8, anchor = BOTTOM);
        }
        // internal thread
        translate([0, 0, P - L_thread - eps])
            trapezoidal_threaded_rod(d = D_major, l = L_thread + 2*eps, pitch = pitch, thread_angle = 90,
                thread_depth = t_depth, starts = thread_starts, internal = true,
                bevel1 = L_plain <= 0.6, bevel2 = false, $slop = thread_slop, anchor = BOTTOM);
        // plain skirt below the threads
        translate([0, 0, z0 - eps])
            cylinder(d = D_major + 2*skirt_plain_gap, h = L_plain + 2*eps);
        translate([0, 0, z0 - eps])
            cylinder(d1 = D_major + 2*skirt_plain_gap + 1.2, d2 = D_major + 2*skirt_plain_gap, h = 0.6);
        // grip flutes
        if (lid_flutes)
            for (i = [0:nfl-1]) rotate(i * 360 / nfl)
                translate([D_lid/2 + 0.45, 0, z0 + 1.2]) cylinder(r = 1.0, h = lid_h - 2.4, $fn = 16);
        if (svg_mode == "engrave" || svg_mode == "inlay")
            translate([0, 0, ztop - svg_depth]) linear_extrude(svg_depth + 1) svg_2d();
    }
    // plug that carries the clamping load down to the top washer
    if (P > 0)
        tube(od = plug_od, id = plug_id, h = P + 0.2, anchor = BOTTOM);
}

// artwork as its own solid (use orientation): inlay fills the recess, raised art sits on top
module lid_art() {
    if (svg_mode == "inlay")
        translate([0, 0, P + top_thick - svg_depth]) linear_extrude(svg_depth) svg_2d();
    if (svg_mode == "raise")
        translate([0, 0, P + top_thick - eps]) linear_extrude(raise_h + eps) svg_2d();
}

// print orientations: face-down normally; upright when the art is raised
module lid_print_xform() {
    if (svg_mode == "raise") translate([0, 0, L_thread + L_plain - P]) children();
    else translate([0, 0, P + top_thick]) rotate([180, 0, 0]) children();
}
module lid_print() { lid_print_xform() weight_lid(); }
module art_print() { lid_print_xform() lid_art(); }

module washer_stack(S) {
    tt = S / n;
    color("silver") for (i = [0:n-1]) translate([0, 0, f_thick + i*tt])
        difference() { cylinder(d = w_od, h = tt - 0.05); translate([0,0,-1]) cylinder(d = w_id, h = tt + 2); }
}

module weight_assembled(S = S_nom, show_washers = true) {
    color("SteelBlue") weight_body();
    color("LightSteelBlue") translate([0, 0, f_thick + S]) weight_lid();
    color("white") translate([0, 0, f_thick + S]) lid_art();
    if (show_washers) washer_stack(S);
}

// ---------------------------------------------------------------------
//  Storage box geometry
// ---------------------------------------------------------------------
module rsq(side, r) { offset(r = r) square(side - 2*r, center = true); }

// extrude a 2D (y, z) profile along +x, starting at x0
module yz_extrude(x0, len) {
    translate([x0, 0, 0]) multmatrix([[0,0,1,0],[1,0,0,0],[0,1,0,0],[0,0,0,1]]) linear_extrude(len) children();
}

// rounded-square prism with 45-degree chamfers (c1 bottom, c2 top)
module rsq_prism(side, r, h, c1 = 0, c2 = 0) {
    hull() {
        linear_extrude(eps) rsq(side - 2*c1, max(0.5, r - c1));
        translate([0, 0, c1]) linear_extrude(h - c1 - c2) rsq(side, r);
        translate([0, 0, h - eps]) linear_extrude(eps) rsq(side - 2*c2, max(0.5, r - c2));
    }
}

// knuckle barrel in the (y, z) profile, its top cut flat at the lid's top face
module barrel_2d() {
    intersection() {
        translate([hinge_y, hinge_z]) circle(r = kr);
        translate([0, -1000]) square([1000, 1000 + box_H + lid_t]);
    }
}

// back hinge: knuckle i belongs to the box if i is even, to the lid if odd
function k_x(i) = -hinge_len/2 + i * (k_len + k_gap);

module box_knuckles() {
    y_s = B_out/2 - box_wall - 6;            // web anchors inside the wall; cavity cut trims it
    drop = hinge_y - y_s + kr * 1.42;        // gives a ~45 degree underside
    for (i = [0 : 2 : n_knuckles-1]) yz_extrude(k_x(i), k_len) {
        barrel_2d();
        intersection() {
            hull() {
                barrel_2d();
                translate([y_s, hinge_z - drop]) square([0.1, drop]);
            }
            // web stays at or below the rim, clear of the lid
            translate([0, -1000]) square([1000, 1000 + min(hinge_z, box_H - 0.3)]);
        }
    }
}

module lid_knuckles() {
    for (i = [1 : 2 : n_knuckles-1]) yz_extrude(k_x(i), k_len) {
        barrel_2d();
        intersection() {
            hull() {
                barrel_2d();
                // anchor block kept inside the plate so no face is shared with the plate's top
                translate([B_out/2 - 4.5, box_H + 0.6]) square([2.5, lid_t - 1.6]);
            }
            translate([0, box_H + 0.3]) square([1000, 100]);         // web underside clear of the plate's underside
        }
    }
}

// Clearance around the other part's knuckles. Its radius and length stop
// half the gap short of everything else, so no surface merely grazes another
// (a near-touch can leave a non-manifold edge in floating-point CSG engines).
module knuckle_clearance(first) {
    for (i = [first : 2 : n_knuckles-1])
        translate([k_x(i) - k_gap/2, hinge_y, hinge_z]) rotate([0, 90, 0])
            cylinder(r = kr + k_gap/2, h = k_len + k_gap);
}

module pin_hole() {
    translate([-B_out, hinge_y, hinge_z]) rotate([0, 90, 0]) cylinder(d = hinge_pin_hole, h = 2*B_out, $fn = 24);
}
// The lid prints face-down, so its pin holes print sideways with their USE-bottom
// facing up. A teardrop pointing that way prints without the sag that closed up
// round holes; the pin bears on the round part.
module lid_pin_hole() {
    d = hinge_pin_hole + lid_pin_extra;
    yz_extrude(-B_out, 2*B_out) hull() {
        translate([hinge_y, hinge_z]) circle(d = d, $fn = 24);
        translate([hinge_y, hinge_z - d/2 * sqrt(2)]) square(0.05, center = true);
    }
}

y_face   = -B_out/2 - boss_p;                  // latch boss outer face (front is -y)
y_cf     = y_face + latch_thickness + l_gap;   // latch channel floor
tab_bot  = box_H - boss_len - tab_tip;         // bottom of the latch tab

module storage_box() {
    difference() {
        union() {
            rsq_prism(B_out, r_out, box_H, c1 = 1.0);
            box_knuckles();
            // latch boss with a 45-degree underside
            yz_extrude(-boss_w/2, boss_w) hull() {
                translate([y_face, box_H - boss_len]) square([boss_p + r_out*0.3, boss_len - 0.3]);   // top 0.3 below the rim
                translate([-B_out/2 + r_out*0.3 - 0.1, box_H - boss_len - boss_p - r_out*0.3]) square([0.1, 0.1]);
            }
        }
        translate([0, 0, box_floor]) linear_extrude(box_H) rsq(B_in, r_in);
        pin_hole();
        knuckle_clearance(1);
        if (box_bottom_art_on)
            translate([0, 0, -1]) linear_extrude(box_svg_depth + 1) box_bottom_svg_2d();
        // latch channel, open through the bottom of the boss
        translate([-(latch_width/2 + l_gap), y_face - 1, tab_bot - 10])
            cube([latch_width + 2*l_gap, y_cf - y_face + 1, box_H - tab_bot + 11]);
        // lead-in chamfer at the top of the channel floor
        yz_extrude(-(latch_width/2 + l_gap), latch_width + 2*l_gap)
            polygon([[y_cf - eps, box_H + eps], [y_cf + latch_hook + 0.3, box_H + eps], [y_cf - eps, box_H - latch_hook - 0.3]]);
        // catch pocket: its flat roof at z_catch is what the hook bears on
        // its roof parallels the hook's tilted face, 0.1 above it
        let(yt = y_face + latch_thickness, t = tan(latch_angle),
            roof = function(y) z_catch + (y - yt) * t)
        yz_extrude(-(latch_width/2 - 1 + l_gap), latch_width - 2 + 2*l_gap)
            polygon([[y_cf - eps, z_catch - latch_hook - 3], [y_cf + latch_hook + 0.3 - l_gap, z_catch - latch_hook - 3],
                     [y_cf + latch_hook + 0.3 - l_gap, roof(y_cf + latch_hook + 0.3 - l_gap)], [y_cf - eps, roof(y_cf - eps)]]);
    }
}

// box lid in USE orientation (sits on the rim at z = box_H)
module box_lid() {
    yt = y_face + latch_thickness;
    zc = z_catch - 0.1;
    difference() {
        union() {
            // Plate and latch tongue as ONE extrusion. Nothing below shares a face
            // with anything else: Manifold-based OpenSCAD leaves a zero-thickness
            // seam (a non-manifold edge in the slicer) wherever unioned solids
            // share a plane.
            translate([0, 0, box_H]) linear_extrude(lid_t) union() {
                rsq(B_out, r_out);
                // tongue over the latch boss: 0.5 proud of the tab, and stopping
                // 0.5 short of the locating lip
                difference() {
                    translate([-boss_w/2, y_face - 0.5]) square([boss_w, -y_face + 0.5]);
                    rsq(B_in - 2*lip_gap + 1.0, max(0.5, r_in - lip_gap + 0.5));
                }
            }
            // locating lip inside the rim (0.3 up into the plate)
            translate([0, 0, box_H - lip_h]) linear_extrude(lip_h + 0.3)
                difference() {
                    rsq(B_in - 2*lip_gap, max(0.5, r_in - lip_gap));
                    rsq(B_in - 2*lip_gap - 2*lip_t, max(0.5, r_in - lip_gap - lip_t));
                }
            lid_knuckles();
            // latch tab and its finger pull: one profile, one extrusion, 0.5 into the plate
            yz_extrude(-latch_width/2, latch_width) union() {
                translate([y_face, tab_bot + 1]) square([latch_thickness, box_H - tab_bot - 1 + 0.5]);
                polygon([[y_face + latch_thickness, tab_bot], [y_face - 1.5, tab_bot], [y_face, tab_bot + 3], [y_face + latch_thickness, tab_bot + 3]]);
            }
            // hook: flat top bears on the pocket roof, 45-degree lead-in below
            yz_extrude(-(latch_width/2 - 1), latch_width - 2)
                let(rise = latch_hook * tan(latch_angle))   // catching face climbs toward the box
                polygon([[yt - 0.3, zc - 0.3 * tan(latch_angle)], [yt + latch_hook, zc + rise],
                         [yt + latch_hook, zc + rise - 0.6], [yt - 0.3, zc - 0.6 - latch_hook - 0.3]]);
        }
        knuckle_clearance(0);
        lid_pin_hole();
        if (box_lid_art_on)
            translate([0, 0, box_H + lid_t - box_svg_depth]) linear_extrude(box_svg_depth + 1) box_lid_svg_2d();
    }
}

// inlay solids for the box (use orientation)
module box_lid_art() {
    if (box_lid_svg_mode == "inlay")
        translate([0, 0, box_H + lid_t - box_svg_depth]) linear_extrude(box_svg_depth) box_lid_svg_2d();
}
module box_bottom_art() {
    if (box_bottom_svg_mode == "inlay") linear_extrude(box_svg_depth) box_bottom_svg_2d();
}

module box_lid_print_xform() { translate([0, 0, box_H + lid_t]) rotate([180, 0, 0]) children(); }
module box_lid_print() { box_lid_print_xform() box_lid(); }

module box_lid_open(a) {
    translate([0, hinge_y, hinge_z]) rotate([-a, 0, 0]) translate([0, -hinge_y, -hinge_z]) box_lid();
}

// ---------------------------------------------------------------------
//  Part selection
// ---------------------------------------------------------------------
gap = 0 + 6;
// All printed parts share one colour and all artwork another, so a slicer that
// reads the 3MF's colours (Bambu Studio's import dialog) starts with exactly two
// filaments and never swaps between identical ones on a shared plate.
PART_COLOR = str("Tan");
ART_COLOR  = str("white");

// Every coloured solid is its own top-level statement, so with OpenSCAD's
// lazy-union feature a 3MF export holds one object per colour; the slicer then
// offers to load them as one multi-part object and asks which filament each
// part gets. (Grouping them would merge them into one solid with only its
// faces coloured, which some slicers ignore.)
lid_dx = D_body/2 + D_lid/2 + gap;
box_dx = B_out + 2*boss_p + 2*kr + gap;
if (part == "weight") {
    color(PART_COLOR) weight_body();
    color(PART_COLOR) translate([lid_dx, 0, 0]) lid_print();
    color(ART_COLOR) translate([lid_dx, 0, 0]) art_print();
}
else if (part == "body") color(PART_COLOR) weight_body();
else if (part == "lid") { color(PART_COLOR) lid_print(); color(ART_COLOR) art_print(); }
else if (part == "lid_only") lid_print();
else if (part == "inlay") art_print();
else if (part == "box") { color(PART_COLOR) storage_box(); color(ART_COLOR) box_bottom_art(); }
else if (part == "box_lid") { color(PART_COLOR) box_lid_print(); color(ART_COLOR) box_lid_print_xform() box_lid_art(); }
else if (part == "box_only") storage_box();
else if (part == "box_lid_only") box_lid_print();
else if (part == "box_lid_in_place") box_lid_open(preview_lid_angle);   // (hidden) for checking fit
else if (part == "box_inlays") {
    box_bottom_art();
    translate([box_dx, 0, 0]) box_lid_print_xform() box_lid_art();
}
else if (part == "box_set") {
    color(PART_COLOR) storage_box();
    color(ART_COLOR) box_bottom_art();
    color(PART_COLOR) translate([box_dx, 0, 0]) box_lid_print();
    color(ART_COLOR) translate([box_dx, 0, 0]) box_lid_print_xform() box_lid_art();
}
else if (part == "weight_cutaway") {
    difference() { weight_assembled(); translate([0, -100, -1]) cube(200); }
}
else if (part == "box_cutaway") {
    difference() {
        union() {
            color("Tan") storage_box();
            color("Wheat") box_lid_open(preview_lid_angle);
            for (i = [0:box_count-1]) translate([0, 0, box_floor + i * H_nom]) weight_assembled();
        }
        translate([-300, -300, -1]) cube([300, 600, 600]);
    }
}
