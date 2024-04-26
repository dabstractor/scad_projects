$fn = 36 * 4;
include <Round-Anything/polyround.scad>
use <threads-scad/threads.scad>

module ThreadedCapStand()
{

    translate([ 0, 0, -12 ]) cylinder(h = 12, d1 = 3.5, d2 = 4.7);
    translate([ 0, 0, -12.6 ]) cylinder(h = 0.6, d1 = 0.2, d2 = 3.5);
    difference()
    {
        cylinder(h = 8, d1 = 4.7, d2 = 4.7 + 6);
        translate([ 0, 0, 3 ]) cylinder(h = 8, d1 = 4.7, d2 = 4.7 + 6);
    }

    // difference()
    // {
    //     union()
    //     {
    // // rotate([ 0, 180, 0 ])
    // // RodStart(0, 0, 4, 6, 2);
    //
    // rotate_extrude(angle = 360) polygon(polyRound(
    //     [
    //         // [ 0, 0, 0 ],
    //         // [ 1.5, 10 / 6 * 1.5, 0 ],
    //         // [ 6, 10, 4 ],
    //         // [ 8, 10, 1 ],
    //         // [ 8, 2, 6 ],
    //         // [ 10, 0, 5 ],
    //         // [ 2.4, -4, 10 ],
    //         // [ 6, 6, 0 ],
    //         // [ 4, 6, 0 ],
    //         [ 2.4, 0, 0 ],
    //         [ 2.4, -9, 0 ],
    //         [ 1.5, -9, 0 ],
    //         [ 1.5, 0, 0 ],
    //
    //     ],
    //     $fn / 5));

    // cylinder(r1 = )
    //     }
    //     // translate([ 0, 0, -20 ]) cylinder(h = 50, d = 3);
    // }
}

render() ThreadedCapStand();
