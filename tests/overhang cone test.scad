$fn = 360;
include <Round-Anything/polyround.scad>
angle = 60;

width = 20;
height = width * cos(angle == 90 || angle == 0 ? 45 : angle);

module cone()
{ // cylinder(d1 = width, h = height);
	rotate_extrude(angle = 360) polygon(polyRound(
	    [
		    // [ 0, 0, 0 ],
		    // [ 0, -height, 0 ],
		    // [ -width, -height, 0 ],
		    // [ -width, 0, 0 ],

		    // [ 0, -1, 0 ],
		    // [ 0, -height / 4, 0 ],
		    // [ width / 2 - 1, -height / 2, 0 ],

		    // [ 0, 0, 0 ],
		    // // [ width / 4, -height / 4, 10 ],
		    // [ 1, -height / 2 + 1, 10 ],
		    // [ width / 2, -height / 2, 0 ],
		    // [ 0, -height / 2, 0 ],

		    [ width / 2, 0, 0 ],
		    // [ height / 4, 0, 20 ],
		    [ 1, 1, 10 ],
		    [ 0, height, 0 ],
		    // [ 0, 0, 0 ],
		    [ 0, height - sin(angle) * 0.8, 0 ],
		    [ 0, 0, 10 ],
		    [ width / 2 - cos(angle) * 0.8, 0, 0 ],

	    ],
	    120));
}

intersection()
{
	cone();
	cylinder(h = height * 0.5, d = width * 0.8);
}

// difference()
// {
// 	cone();

// 	translate([ 0, 0, -cos(angle) * 0.8 ])
// 	cone();
// }
