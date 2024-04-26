$fn = 360;
include <Round-Anything/polyround.scad>

include <rotate-around-axis/rotate_around_axis.scad>
use <threads-scad/threads.scad>

collar_depth = 10;

function inchToMm(value) = 25.4 * value;

thread_outer_diameter_1_2 = inchToMm(0.840); // Outer diameter of the pipe
rod_outer_diameter = thread_outer_diameter_1_2 + 1;
thread_outer_diameter_3_4 = inchToMm(1.050); // Outer diameter of the pipe
thread_pitch = inchToMm(1/14); // Thread pitch in mm (1/14 inches, NPT 1/2"and 3/4" standard)
thread_length = collar_depth; // Length of the threads in mm (1/2" standard)

module adapter()
{
    difference() {
      RodStart(rod_outer_diameter, 0, collar_depth, thread_outer_diameter_3_4, thread_pitch);
      translate([0,0, -0.1])
      cylinder(h=collar_depth + 0.2, d=thread_outer_diameter_1_2, center=false);
      // translate([0,0, collar_depth -1])
      // cylinder(h=collar_depth + 0.1, d=thread_outer_diameter_1_2 - 2.2, center=false);
    }
    RodEnd(rod_outer_diameter, collar_depth, collar_depth, thread_outer_diameter_1_2, thread_pitch);
}

adapter();