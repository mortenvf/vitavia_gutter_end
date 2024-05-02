
$fn=50;

//
// This is a model for a replacement downpipe adaptor for Vitavia greenhouses,
// it can be used to replace a broken original part, or to add downpipes in
// additional corners of the greenhouse. It can also be modified if you
// want to fit a different type of downpipe.
//

// this describes one half of the gutter profile, it is mirrored to make the whole shape
g_profile = [[0,0],[-37/2,0],[-39/2,18.5],[-35/2,22.5],[0,22.5]];

g_gutter_extend_in = 100;
g_gutter_extend_out = 16;
g_gutter_endcap_thickness = 2;

g_downpipe_length = 60;
g_downpipe_outer_diam = 20;
g_downpipe_thickness = 4;
g_downpipe_extend_inner = 4; // extend downpipe inner to break through gutter bottom


g_sidepipe_adjust_y = 5;
g_sidepipe_length = 60;
g_sidepipe_outer_diam = 32;
g_sidepipe_thickness = 4;


module gutter_profile_outer()
{
    polygon(g_profile);
    scale([-1,1,1]) polygon(g_profile);
}

module gutter_profile_inner()
{
    // this is a shrunken version of the gutter profile, used
    // to subtract from the full size one to make it hollow, this
    // is a bit nasty, would be better to describe a thickness in mm instead
    // of a scaling factor.
    union() {
        scale([0.925, 0.925,1])
          translate([0, 1.6, 0])
            gutter_profile_outer();
        polygon([[0, 5], g_profile[3], [-g_profile[3][0], g_profile[3][1]], [0, 5]]);
    }
}


difference() {
    
    union() {
        
        // Outer gutter
        translate([0, 0, -g_gutter_extend_out])
            linear_extrude(height = g_gutter_extend_in + g_gutter_extend_out)
                gutter_profile_outer();
        
        // Downpipe outer
        translate([0,-g_downpipe_length/2,0]) rotate([90,0,0]) cylinder(d=g_downpipe_outer_diam, h=g_downpipe_length, center=true, $fn=100);
        
        // Sidepipe outer
        translate([-g_sidepipe_length/2,g_sidepipe_adjust_y,0])
            rotate([0,90,0])
            union() {
                translate([0,0,g_sidepipe_length/2])
                   sphere(d=g_sidepipe_outer_diam);
                cylinder(d=g_sidepipe_outer_diam, h=g_sidepipe_length, center=true);
            };
        
        
    }
    
    union() {
         // Inner gutter
         translate([0, 0, -g_gutter_extend_out + g_gutter_endcap_thickness])
            linear_extrude(height = g_gutter_extend_in + g_gutter_extend_out)
                gutter_profile_inner();
        
                // Downpipe inner
        translate([0,-g_downpipe_length/2,0]) rotate([90,0,0]) cylinder(d=g_downpipe_outer_diam-g_downpipe_thickness, h=g_downpipe_length+g_downpipe_extend_inner, center=true);
        
        
        // Sidepipe inner
        translate([-g_sidepipe_length/2,g_sidepipe_adjust_y,0]) rotate([0,90,0])
        union(){
            
                translate([0,0,g_sidepipe_length/2])
                   sphere(d=g_sidepipe_outer_diam-g_sidepipe_thickness);
            cylinder(d=g_sidepipe_outer_diam-g_sidepipe_thickness, h=g_sidepipe_length, center=true);
        }
        
    }
}

