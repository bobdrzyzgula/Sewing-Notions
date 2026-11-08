// Needle Disposal Bin v0.9 2/28/2026
//
//  This code will generate a "sharps container" for used and broken sewing needles. Drop your worn needles in here until it is full, and then simply discard. Needles should drop in but not fall out. The device will print entirely closed, there is no way to open it save cutting it with a saw. Note that it is *not impossible* to shake a needle out of the device but it is extremely unlikely for them to fall out by accident. This should be printable without support and without an AMS. If your slicer wants to build supports, try increasing the angle of the funnel; the post in the middle should provide enough support as long as the cantelever isn't too shallow. The default hole diameter is 3.2mm, which should be sufficient for most common sewing machine and hand-sewing needles. Switchs allow the turning on and off of the various components, which is useful if you want to see what's going on inside. Setting "generate_shell=0" and "generate_pedistal=1" will generate a version with no walls but with a stand, which is useful if you want to see or show someone how it works. I've also had some stringing between the two pilars of the post with some filament, so printing without a shell will help diagnose such issues.
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
    };
}

if (generate_pedistal > 0) {
    cylinder(h=pedistal_thickness,r=pedistal_radius,center=false,$fn=pedistal_sides);
}