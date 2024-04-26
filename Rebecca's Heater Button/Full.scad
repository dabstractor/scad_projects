$fn = 360;
include <tjw-scad/dfm.scad>
include <tjw-scad/moves.scad>
use <tjw-scad/spline.scad>

module button()
{

	// rotate([ 0, -5, 0 ])
	rotate([ 0, -86, 0 ])
	translate([ -800, 0, 0 ])
	rotate_extrude(angle = 10) translate([ 800, 0, 0 ])
	square([ 1.6, 60 ]);
}

button();
mirror([ 0, 1 ]) color("pink") button();
