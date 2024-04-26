$fn = 360;
include <Round-Anything/polyround.scad>

include <rotate-around-axis/rotate_around_axis.scad>
use <threads-scad/threads.scad>

collar_depth = 10;

thread_outer_diameter = 25.4 * 0.840; // Outer diameter of the pipe
rod_outer_diameter = thread_outer_diameter + 5;
thread_pitch = 1.8144; // Thread pitch in mm (1/14 inches, NPT 1/2" standard)
// thread_pitch = 0;
thread_length = collar_depth; // Length of the threads in mm (1/2" standard)
// Length of the threads

handle_thickness = 3;
finger_prongs = 6;
prong_length = 8;

bulkhead_depth = 3;

module nut()
{

    difference()
    {

        // union()
        // {
        //     cylinder(collar_depth, rod_outer_diameter / 2, rod_outer_diameter / 2, [ 0, 0, 0 ]);
        for (i = [0:finger_prongs])
        {
            rotate_around_axis(0, 0, 360 / finger_prongs * i, [ 0, 0, collar_depth / 2 ])
                translate([ rod_outer_diameter / 2 - 1, -handle_thickness / 2, 0 ]) difference()
            {

                union()
                {

                    cube([ prong_length, handle_thickness, collar_depth ]);

                    polyRoundExtrude(
                        [
                            [ -5, -10, 0 ], [ 2, -4, 4 ], [ prong_length / 2, 0, 4 ], [ prong_length, 0, 2 ],
                            [ prong_length, handle_thickness, 2 ], [ 0, handle_thickness, 0 ]
                        ],
                        collar_depth, 0, 0);

                    translate([ 0, 3, collar_depth ]) rotate([ 180, 0, 0 ]) polyRoundExtrude(
                        [
                            [ -5, -10, 0 ], [ 2, -4, 4 ], [ prong_length / 2, 0, 4 ], [ prong_length, 0, 2 ],
                            [ prong_length, handle_thickness, 2 ], [ 0, handle_thickness, 0 ]
                        ],
                        collar_depth, 0, 0);
                }
            }
        }
        translate([ 0, 0, -0.5 ]) cylinder(collar_depth + 1, rod_outer_diameter / 2, rod_outer_diameter / 2);
    }
    RodEnd(rod_outer_diameter, collar_depth, collar_depth, thread_outer_diameter, thread_pitch);
}

module seal()
{
    radius = rod_outer_diameter / 2 + prong_length;
    cutout_radius = thread_outer_diameter / 2 + 0.2;
    location_z = -bulkhead_depth - 0.1;

    difference()
    {
        translate([ 0, 0, location_z ]) cylinder(bulkhead_depth, radius, radius);
        translate([ 0, 0, location_z - 0.1 ]) cylinder(bulkhead_depth + 1, cutout_radius, cutout_radius);
    }

}

nut();
seal();