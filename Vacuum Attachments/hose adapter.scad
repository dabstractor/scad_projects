$fn = 120;
use <threads-scad/threads.scad>

module adapter()
{
    translate([ 0, 0, 22.5 ]) cube([ 10, 50, 5 ], center = true);
    cylinder(h = 50, d = 42, center = true, $fn = 360);
}

difference()
{
    adapter();
    cylinder(h = 70, d = 38.4, center = true, $fn = 360);
}
