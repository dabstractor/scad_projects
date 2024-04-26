$fn = 36 * 1;
use <Rounded_Cube.scad>
use <threads-scad/threads.scad>

inner_radius = 33 / 2;
inner_diameter = inner_radius * 2;
container_radius = inner_radius + wall_thickness;
container_diameter = container_radius * 2;

show_left_side = true;
show_right_side = true;

wire_depth = 1.6;
wire_width = 6.25;

air_hole_size = 2;

lip_size = 3;

module ball()
{
	wall_thickness = 2;

	difference()
	{
		sphere(inner_radius + wall_thickness);
		ballCutout();

		holes();

		translate([ 0, 0, inner_radius + wall_thickness / 2 ])
		rounded_cube(wire_depth, wire_width, inner_radius, wire_depth / 2, center = true);
	}
}

module ballCutout()
{
	intersection()
	{
		cube([ inner_diameter, inner_radius * 1.5, inner_diameter ], center = true);
		sphere(inner_radius);
	}
}

module sides()
{

	module splitterCube()
	{
		color([ 1, 0.2, 0.7 ], 0.1) cube(container_diameter, center = true);
	}

	module sideBlock()
	{
		difference()
		{

			cube(container_diameter, center = true);
		}
	}

	inner_cube_size = inner_diameter + wall_thickness * 2;
	inner_sphere_size = inner_radius;

	module rightSide()
	{
		difference()
		{

			union()
			{

				difference()
				{

					sphere(inner_radius);
					translate([ -inner_radius, 0, 0 ])
					cube(inner_diameter, center = true);

					cube([ inner_diameter, inner_radius - 4, inner_diameter ], center = true);
				}
				intersection()
				{

					translate([ inner_radius / 2 - lip_size - 0.2, 0, 0 ])
					cube([ inner_radius, inner_radius * 1.5 - 0.4, inner_radius ], center = true);
					sphere(inner_radius);
				}

				intersection()
				{

					// cube(inner_radius, center = true) scale(0.98) ballCutout();

					sphere(inner_radius);
					difference()
					{

						sphere(inner_sphere_size);
						translate([ inner_radius - lip_size - 0.2, 0, 0 ])
						cube(inner_diameter, center = true);
					}
					color([ 1, 0, 1 ], 0.1) cube([ inner_radius, inner_diameter, inner_radius ], center = true);
				}
			}

			color([ 1, 0, 0 ]) cube([ inner_diameter, inner_radius - 4, inner_radius ], center = true);

			difference()
			{
				holes();
				// rotate([ 0, 0, 180 ])
				translate([ -container_radius, 0, 0 ])
				cube([ container_diameter, container_diameter * 2, container_diameter * 2 ], center = true);
			}
		}
		difference()
		{

			ball();

			translate([ -container_radius, 0, 0 ])
			splitterCube();
		}
	}

	module leftSide()
	{
		module cutoutBall()
		{

			// translate([ 0, cube_size / 2 + inner_radius / 2, 0 ])

			difference()
			{

				intersection()
				{

					// cube([ inner_diameter, inner_radius, cube_size ], center = true);
					sphere(inner_sphere_size - 1);
				}

				translate([ inner_cube_size / 2 - lip_size, 0, 0 ])
				cube(inner_cube_size, center = true);
			}
		}

		union()
		{

			difference()
			{
				ball();
				translate([ container_radius, 0, 0 ])
				splitterCube();
				cutoutBall();
			}
		}
	}

	union()
	{
		if (show_right_side)
			rightSide();

		if (show_left_side)
			leftSide();
	}
}

module holes()
{
	module hole()
	{
		translate([ 0, 0, -inner_radius ])
		cylinder(inner_diameter, d = air_hole_size, center = true, $fn = 10);
	}

	rows = 6;

	for (i = [0:rows])
	{
		items = ((i / rows) + (i / rows) % 2) * 9;
		rotate([ 0, 0, -90 ])
		for (j = [0:items])
		{
			y_rotate = i > 0 ? 45 / rows * i : 0;
			translate([ 0, 0, inner_radius / 2 / rows * i ])
			rotate([ 0, y_rotate, items == 0 ? 0 : j * 360 / items ])
			hole();
		}
	}
}

module cover()
{
	sides();
}

// cover();

module squareCover()
{

	wall_thickness = 1;
	total_height = inner_radius * 2 + wall_thickness * 2;
	total_width = wire_width + wall_thickness * 2;
	total_depth = wire_width / 2 + wall_thickness * 2;
	top_width = wire_depth + wall_thickness * 2;
	echo("total_height:", total_height);

	module outline()
	{
		intersection()
		{
			cylinder(total_height, r1 = total_width * 2, r2 = top_width * 2, center = true);

			translate([ 0, 0, total_height / 2 ])
			rounded_cube(total_width, total_width * 2, total_height, [ 0, 0, wall_thickness ], center = true);
		}
	}

	module holes()
	{
		hole_angle = 130;
		module hole()
		{
			rotate([ hole_angle, 0, 0 ])
			cylinder(abs(tan(180 - hole_angle)) * total_width * 2, d = air_hole_size, center = true, $fn = 6);
		}
		// hole();

		for (i = [0:(total_height / (2 * air_hole_size)) - 4])
		{

			// translate([ 0, 0, i * 2 * air_hole_size ])
			// hole();
			divisions = 10;
			angular_shift = 180 / divisions;

			for (j = [0:divisions])
			{
				layer_size = 2 * air_hole_size;
				partial_layer = cos(hole_angle) * (layer_size / divisions);
				// translate([ 0, 0, i * layer_size + partial_layer * j ])
				// rotate([ 0, 0, j * 360 / divisions + angular_shift * i / 2 ])

				translate([ 0, 0, i * layer_size ])
				rotate([ 0, 0, j * 360 / divisions + i % 2 * angular_shift ])
				translate([ 0, -total_width / 1.5, 2 ])
				hole();
			}
		}
	}

	module wireCutout()
	{
		rotate([ 0, 0, 90 ])
		translate([ 0, 0, total_height / 2 ])
		rounded_cube(wire_width, wire_depth, total_height * 1.5, wire_depth / 2, center = true);
	}

	difference()
	{

		hull()
		{

			outline();
			difference()
			{

				scale([ 1.2, 1.2, 1 ]) wireCutout();
				wireCutout();
				cube(total_height * 1.5, center = true);
			}
		}
		scale([ 1, 1, 10 ]) wireCutout();

		scale_factor = wire_width / total_width;
		scale([ scale_factor, scale_factor, scale_factor ]) outline();

		holes();

		difference()
		{

			// translate([ 0, 0, -40 ])
			rotate([ 0, 90, 0 ])
			rounded_cube(total_height * 2, 12, 3, 1, center = true);

			dogear();
			mirror([ 0, 1, 0 ]) dogear();
		}
	}

	module dogear()
	{

		translate([ 0, 15, 35 ])
		rotate([ -60, 0, 0 ])
		cube(25, center = true);
	}
}

squareCover();
