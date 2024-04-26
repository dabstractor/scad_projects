include <Round-Anything/polyround.scad>
// Create the cube with rounded corners in 2 dimensions

module rounded_cube(width, length, height, radii = 0)
{

	module makeCube(top, bottom, top_left, top_right, bottom_left, bottom_right)
	{
		polyRoundExtrude(
		    [
			    [ 0, 0, bottom_left ], [ 0, length, top_left ], [ width, length, top_right ], [ width, 0, bottom_right ]
		    ],
		    height, top, bottom);
	}

	top_radius = radii;
	bottom_radius = radii;
	top_left_radius = radii;
	top_right_radius = radii;
	bottom_left_radius = radii;
	bottom_right_radius = radii;

	if (is_list(radii))
	{
		if (is_undef(radii[2]))
		{
			makeCube(radii[0], radii[0], radii[1], radii[1], radii[1], radii[1]);
		}
		else
		{

			top_radius = radii[0];
			bottom_radius = radii[1];
			top_left_radius = radii[2];
			top_right_radius = radii[3];
			bottom_left_radius = radii[4];
			bottom_right_radius = radii[5];

			if (is_undef(radii[3]))
			{
				makeCube(radii[0], radii[1], radii[2], radii[2], radii[2], radii[2]);
			}
			else
			{
				makeCube(radii[0], radii[1], radii[2], radii[3], radii[4], radii[5]);
			}
		}
	}
	else
	{
		makeCube(top_radius, bottom_radius, top_left_radius, top_right_radius, bottom_left_radius, bottom_right_radius);
	}
}
