// SPDX-License-Identifier: MIT
// Needle Bin II, version 0.11, 10/29/2026
// (descended from Needle Disposal Bin v0.9, "Needle Bin I", by Robert Drzyzgula)
//
//  This code will generate a "sharps container" for used and broken sewing needles. Drop your worn needles in here until it is full, and then simply discard. Needles should drop in but not fall out. The device will print entirely closed, there is no way to open it save cutting it with a saw. Note that it is *not impossible* to shake a needle out of the device but it is extremely unlikely for them to fall out by accident. This should be printable without support and without an AMS. If your slicer wants to build supports, try increasing the angle of the funnel; the post in the middle should provide enough support as long as the cantelever isn't too shallow. The default hole diameter is 3.2mm, which should be sufficient for most common sewing machine and hand-sewing needles. Switchs allow the turning on and off of the various components, which is useful if you want to see what's going on inside. Setting "generate_shell=0" and "generate_pedistal=1" will generate a version with no walls but with a stand, which is useful if you want to see or show someone how it works. I've also had some stringing between the two pilars of the post with some filament, so printing without a shell will help diagnose such issues.
//
//  v0.10: Two optional slots for recessed SVG artwork (a logo, or text laid out as an SVG) on
//  the side of the shell. When the shell has few facets (shell_facets <= flat_face_limit) each
//  one is laid flat on the face nearest the requested angle and can be auto-sized to fit that
//  face. With more facets the artwork is wrapped around the wall so the recess depth stays even.
//  v0.11: Artwork can be sized as a percentage of the face width or height (measured on the bin,
//  after rotation) or in millimeters, and centered vertically on the side of the bin.
//  The SVG placement feature was written by Claude (Anthropic) at the author's direction.
//
// Copyright 2026, Robert Drzyzgula, bob@drzyzgula.org

// Radius of the needle hole in mm
hole_radius = 1.6;
// Maximum length of a needle that can be stored in this device.
max_needle_length = 55;
// Outside raidius of the final project. E.g etting this to 12.7 will result in a device one inch in diameter.
outer_radius = 20;
// Number of facets of the outer shell, the higher the more round
shell_facets = 300;
// Number of facets for the pin hole, post, etc.
round_facets=60;
// Thickness of the outer walls
wall_thickness = 2.5;
// The angle of the funnel sides. This should be greater than your filament's threshold cantelever angle for needing support. Must be greater than zero and less than 90 degrees or the math doesn't work.
funnel_angle = 40;
// Amount to overlap objects to properly merge them
overlap = 0.5;
// Outer shell will be generated if this is positive. Easiest way to see what's going on inside is to set this to zero and then set it back to 1 for the print.
generate_shell = 1;
// Switch to generate the post (for model inspection purposes)
generate_post = 1;
// Switch to generate the upper funnel
generate_funnel = 1;
// Switch to generate a pedistal, useful if you make one without a shell for demostration purposes
generate_pedistal = 0;
// How many sides to the pedistal; default is a pentagon
pedistal_sides = 5;
// Outside radius of the pedistal
pedistal_radius = 1.5*outer_radius;
// Thickness of the pedistal. Needs to be at least wall_thickness. If you make a thick pedistal, it will "swallow" some of the post -- the post and funnel will not be raised to compensate.
pedistal_thickness = wall_thickness;

/* [Logo 1] */
// SVG file to recess into the shell (same folder as this .scad file). Leave empty for none.
logo1_file = "";
// How the artwork is sized: as a percentage of the face, or in millimeters
logo1_size_mode = "percent"; // [percent, mm]
// Percent mode: size of the artwork as a percentage of the face dimension chosen below (proportions are kept)
logo1_percent = 80; // [5:1:100]
// Percent mode: which face dimension the percentage applies to, as seen on the bin (after rotation)
logo1_fit_to = "width"; // [width, height]
// mm mode: width on the bin in mm. Set one of width/height to 0 to keep the SVG's proportions.
logo1_width = 25;
// mm mode: height on the bin in mm. Set one of width/height to 0 to keep the SVG's proportions.
logo1_height = 0;
// Center the artwork vertically on the side of the bin (ignores z)
logo1_center = true;
// Height of the center of the artwork above the bottom of the shell, mm (used when center is off)
logo1_z = 35;
// Position around the shell in degrees. 0 faces -Y (OpenSCAD's Front view); 180 is the back. On flat faces this snaps to the nearest face.
logo1_angle = 0;
// Rotation on the surface: 0 = as drawn, 90 = runs bottom to top, -90 = top to bottom
logo1_rotate = 0;
// Depth of the recess in mm; must be less than wall_thickness
logo1_depth = 0.8;

/* [Logo 2] */
// SVG file to recess into the shell (same folder as this .scad file). Leave empty for none.
logo2_file = "";
// How the artwork is sized: as a percentage of the face, or in millimeters
logo2_size_mode = "percent"; // [percent, mm]
// Percent mode: size of the artwork as a percentage of the face dimension chosen below (proportions are kept)
logo2_percent = 80; // [5:1:100]
// Percent mode: which face dimension the percentage applies to, as seen on the bin (after rotation)
logo2_fit_to = "width"; // [width, height]
// mm mode: width on the bin in mm. Set one of width/height to 0 to keep the SVG's proportions.
logo2_width = 25;
// mm mode: height on the bin in mm. Set one of width/height to 0 to keep the SVG's proportions.
logo2_height = 0;
// Center the artwork vertically on the side of the bin (ignores z)
logo2_center = true;
// Height of the center of the artwork above the bottom of the shell, mm (used when center is off)
logo2_z = 35;
// Position around the shell in degrees. 0 faces -Y (OpenSCAD's Front view); 180 is the back. On flat faces this snaps to the nearest face.
logo2_angle = 180;
// Rotation on the surface: 0 = as drawn, 90 = runs bottom to top, -90 = top to bottom
logo2_rotate = 0;
// Depth of the recess in mm; must be less than wall_thickness
logo2_depth = 0.8;

/* [Face placement] */
// Shells with this many facets or fewer get artwork laid flat on a single face; more facets get wrapped artwork.
flat_face_limit = 8;
// Round (wrapped) shells: how much of the circumference counts as one "face" for percent sizing, degrees
round_face_angle = 120; // [30:5:300]

/* [Wrapping] */
// Width of the flat strips used to bend a label around the shell, mm. Smaller is smoother but slower to render.
wrap_strip = 0.4;
// Widest label (measured around the shell) that will be wrapped, mm. 0 = half way around the shell.
wrap_span = 0;

/* [Hidden] */
// true when labels go flat on a face
flat_mode = shell_facets <= flat_face_limit;
// distance from the axis to the middle of a face (equals outer_radius for a true circle)
apothem = outer_radius*cos(180/shell_facets);
// width of one flat face
face_width = 2*outer_radius*sin(180/shell_facets);
// how far the corners of the shell stand proud of the apothem
sagitta = outer_radius - apothem;
// thickness of the wall measured perpendicular to a face
wall_normal = wall_thickness*cos(180/shell_facets);
// height of the outer shell
shell_height = max_needle_length+tan(funnel_angle)*(outer_radius-hole_radius)+2*hole_radius+wall_thickness;
// the "face" used for percent sizing: one flat face, or an arc of round_face_angle on a wrapped shell
face_w = flat_mode ? face_width : round_face_angle/360*2*PI*apothem;
face_h = shell_height;
// strip span for wrapping: half way round, or the face arc if that is wider
span = wrap_span > 0 ? wrap_span : max(PI*apothem, face_w + 2);

assert(logo1_depth < wall_normal, "logo1_depth must be less than the wall thickness measured across a face");
assert(logo2_depth < wall_normal, "logo2_depth must be less than the wall thickness measured across a face");

any_logo = logo1_file != "" || logo2_file != "";

if (any_logo)
    echo(str(flat_mode ? "Flat faces: " : "Wrapped: ", "a face is ", face_w, " mm wide (",
        flat_mode ? str(shell_facets, " faces") : str(round_face_angle, " degrees of arc"), ") and ",
        face_h, " mm tall", flat_mode ? "; anything wider than the face is trimmed at its edges." : "."));

function logo_z(center, z) = center ? shell_height/2 : z;

// Warn when artwork sized by height would run off the top or bottom of the shell
module check_height(n, mode, pct, fit, h, center, z) {
    hh = (mode == "percent" && fit == "height") ? pct/100*face_h : (mode == "mm" ? h : 0);
    zz = logo_z(center, z);
    if (hh > 0 && (zz - hh/2 < 0 || zz + hh/2 > shell_height))
        echo(str("WARNING: logo ", n, " is ", hh, " mm tall centered at z = ", zz,
            " and runs past the end of the ", shell_height, " mm shell."));
}
check_height(1, logo1_size_mode, logo1_percent, logo1_fit_to, logo1_height, logo1_center, logo1_z);
check_height(2, logo2_size_mode, logo2_percent, logo2_fit_to, logo2_height, logo2_center, logo2_z);

if (!flat_mode && any_logo && sagitta > 0.1)
    echo(str("WARNING: with ", shell_facets, " facets a wrapped label will cross the face edges and its ",
        "depth will vary by up to ", sagitta, " mm. Use ", flat_face_limit, " or fewer facets for flat ",
        "labels, or many more facets for a round shell."));

// Rotation that brings the -Y direction onto the center of the face nearest "angle"
// (the faces of an OpenSCAD polygon are centered at 180/n + k*360/n degrees from +X).
function face_rotation(angle) =
    let (step = 360/shell_facets,
         k = round((270 + angle - 180/shell_facets) / step))
    180/shell_facets + k*step - 270;

// An SVG, flat, centered on the origin, rotated, then sized in the bin's frame (width = around
// the bin, height = up the bin), so sizes mean the same thing whatever the rotation.
module logo_2d(file, mode, pct, fit, width, height, rot) {
    if (mode == "percent")
        resize(fit == "height" ? [0, pct/100*face_h] : [pct/100*face_w, 0], auto=true)
            rotate(rot) import(file, center=true);
    else
        resize([width, height], auto=true)
            rotate(rot) import(file, center=true);
}

// Puts a flat 2D child, centered on the origin, onto the shell as a cutting tool, choosing flat
// or wrapped placement by the number of shell facets.
module place_label(z, angle, depth) {
    if (flat_mode)
        flat_on_face(z, angle, depth) children();
    else
        wrap_on_shell(z, angle, depth) children();
}

// Recesses a flat 2D child "depth" mm into the face nearest "angle". Anything wider than the
// face is trimmed so the cut never runs around a corner onto the next face.
module flat_on_face(z, angle, depth) {
    rotate([0, 0, face_rotation(angle)])
        translate([0, -apothem + depth, z])
            rotate([90, 0, 0])
                linear_extrude(height = depth + 1)
                    intersection() {
                        children();
                        square([face_width - 1, 2000], center=true);
                    }
}

// Takes a flat 2D child centered on the origin and turns it into a cutting tool that recesses it
// "depth" mm into the outer surface of the shell. The child is sliced into narrow vertical strips;
// each strip is stood up, pushed into the wall, and rotated around the axis by its arc-length
// position, so the shape wraps around the cylinder instead of being projected onto it.
// The wrap is done at the apothem, so on a faceted shell the recess is never shallower than
// "depth" (it is deeper toward the corners by up to the sagitta).
module wrap_on_shell(z, angle, depth) {
    n = ceil(span / wrap_strip);
    rotate([0, 0, angle])
        translate([0, 0, z])
            for (i = [0 : n-1]) {
                x0 = -span/2 + i*wrap_strip;
                xc = x0 + wrap_strip/2;
                rotate([0, 0, xc/apothem*180/PI])
                    translate([0, -apothem + depth, 0])
                        rotate([90, 0, 0])
                            linear_extrude(height = depth + 1)
                                translate([-xc, 0])
                                    intersection() {
                                        children();
                                        // slightly wide so adjacent strips overlap
                                        translate([x0 - 0.01, -1000])
                                            square([wrap_strip + 0.02, 2000]);
                                    }
            }
}

difference() {
    union() {
        if(generate_funnel >0) {
            difference() {
                translate([0,0,max_needle_length+wall_thickness+hole_radius*2])
                    cylinder(h=tan(funnel_angle)*(outer_radius-hole_radius),
                        r1=hole_radius,
                        r2=outer_radius,
                        $fn=shell_facets);
                translate([0,0,max_needle_length+wall_thickness*2+hole_radius*2])
                    cylinder(h=tan(funnel_angle)*(outer_radius-hole_radius)-wall_thickness+overlap,
                        r1=hole_radius,
                        r2=outer_radius-wall_thickness+overlap/tan(funnel_angle),
                        $fn=shell_facets);
            }
        }    
        if(generate_post>0) {
            difference() {
                difference() {
                    translate([0,0,wall_thickness-overlap])
                        cylinder(h=max_needle_length+2*hole_radius+wall_thickness*tan(funnel_angle),
                            r=hole_radius*3,
                            center=false,
                            $fn=round_facets);
                    translate([0,0,(max_needle_length/2)+wall_thickness-overlap])
                        cube([hole_radius*2,hole_radius*7,max_needle_length+overlap], center=true);
                }
                translate([0,4*hole_radius,max_needle_length+wall_thickness])
                    rotate([90,0,0])
                        cylinder(h=8*hole_radius,r=hole_radius,$fn=round_facets);
             }
        }
    }
   translate([0,0,max_needle_length/2])
    cylinder(h=max_needle_length,
        r=hole_radius,center=false,
        $fn=round_facets);
}
if (generate_shell > 0) {
    difference () {
        cylinder(h=max_needle_length+tan(funnel_angle)*(outer_radius-hole_radius)+2*hole_radius+wall_thickness,
            r=outer_radius,
            center=false,
            $fn=shell_facets);
        translate([0,0,wall_thickness])
            cylinder(h=max_needle_length+tan(funnel_angle)*outer_radius+3*hole_radius+overlap,
            r=outer_radius-wall_thickness,
            center=false,
            $fn=shell_facets);
        if (logo1_file != "")
            place_label(logo_z(logo1_center, logo1_z), logo1_angle, logo1_depth)
                logo_2d(logo1_file, logo1_size_mode, logo1_percent, logo1_fit_to,
                    logo1_width, logo1_height, logo1_rotate);
        if (logo2_file != "")
            place_label(logo_z(logo2_center, logo2_z), logo2_angle, logo2_depth)
                logo_2d(logo2_file, logo2_size_mode, logo2_percent, logo2_fit_to,
                    logo2_width, logo2_height, logo2_rotate);
    };
}

if (generate_pedistal > 0) {
    cylinder(h=pedistal_thickness,r=pedistal_radius,center=false,$fn=pedistal_sides);
}
