$fn = 50;
// include <Round-Anything/polyround.scad>
include <Rounded_Cube.scad>
use <threads-scad/threads.scad>
include <rotate_around_axis.scad>
// all units in mm or deg

item_height = 26; // include a small amount of padding for comfort, I like 2mm
item_width = 36;  // include a small amount of padding for comfort, I like 2mm

shelf_rows = 3;
shelf_columns = 5;

maximum_degrees_of_freedom = 124;

item_sides = 4;
item_sides_corner_radius = 2;

min_arm_width = 4;
arm_thickness = 3;

render_angle_degree = 124;
items_bottom_corner_radius = 0;

axis_size = 4;

print_in_place = true;
spring_bolt_thread_size = 3;
spring_bolt_thread_pitch = 0.5;
min_spring_distance = 60;
mounting_bracket_extra_height = 6;

// item_height = 26; // include a small amount of padding for comfort, I like 2mm
// item_width = 90;  // include a small amount of padding for comfort, I like 2mm

// item_height = 60; // include a small amount of padding for comfort, I like 2mm
// item_width = 26;  // include a small amount of padding for comfort, I like 2mm

// first_shelf_offset = 4;
show_dummy_items = false;

wall_width = 2;
inner_divider_width = wall_width;
lip_height = 5;
item_bottom_corner_radius = 0;

bolt_arm_clearance = 0.4; // for preventing arms from sticking to joints when printing-in-place

first_shelf_offset = 10;
cut_out_back_corner = true;
cut_out_front_corner = true;

// do not edit anything beyond this line

module hideawayShelves()
{

	render_angle = max(0, min(render_angle_degree, maximum_degrees_of_freedom));
	// render_angle = maximum_degrees_of_freedom * $t;

	total_height = wall_width + item_height;

	shelf_width = wall_width + shelf_columns * (wall_width + item_width);
	shelf_height = wall_width + lip_height;
	shelf_depth = wall_width * 2 + item_width;

	distance_between_rotational_axes = 0;
	item_radius = item_width / 2;

	max_arm_width = min(total_height, shelf_depth) / 2 - bolt_arm_clearance / 4;
	// arm_width = max(min_arm_width, max_arm_width); // todo: figure out how to calculate this based on peg size
	// arm_width = 7;
	max_angle = 180 - maximum_degrees_of_freedom;
	item_sides = max(3, item_sides); // lower will cause infinities and zeroes
	echo("total_height:", total_height);
	echo("shelf_depth:", shelf_depth);

	// echo("shelf_depth:");
	// echo(shelf_depth);
	// echo("total_height:");
	// echo(total_height);
	// echo("tan(max_angle):");
	// echo(tan(max_angle));
	// echo("tan(max_angle) * shelf_depth - total_height:");
	// echo(tan(max_angle) * -shelf_depth - total_height);
	// echo("tan(max_angle) - 1 + 3 * sqrt(1 + tan(max_angle) ^ 2):");
	// echo(tan(max_angle) - 1 + 3 * sqrt(1 + tan(max_angle) ^ 2));

	// echo("(tan(max_angle) * shelf_depth - total_height) / (tan(max_angle) - 1 + 3 * sqrt(1 + tan(max_angle) ^ 2)):");
	// echo((tan(max_angle) * -shelf_depth - total_height) / (tan(max_angle) - 1 + 3 * sqrt(1 + tan(max_angle) ^ 2)));

	function cot(a) = 1 / tan(a);
	function sec(a) = 1 / sin(a);
	function csc(a) = 1 / cos(a);

	arm_radius =
	    min((tan(max_angle) * shelf_depth - total_height) / (tan(max_angle) - 1 + 3 * sqrt(1 + tan(max_angle) ^ 2)),
	        shelf_depth / 4, total_height / 4);

	// arm_width = min(potential_arm_radius * 2, shelf_depth / 2, total_height / 2);
	arm_width = arm_radius * 2;
	// arm_radius = arm_width / 2;

	bolt_hole_size = arm_width / 2;
	bolt_head_size = arm_width;
	bolt_head_taper_angle = 0;

	shelf_leg_width = shelf_depth / 4;
	shelf_leg_depth = shelf_leg_width / 3;

	leg_offset = shelf_leg_depth - wall_width;
	shelf_width_with_legs = leg_offset / 2 + wall_width + shelf_width;

	arm_inset = arm_width / 2;
	arm_offset = arm_width / tan(max_angle) - cot(max_angle) * (arm_radius - cos(max_angle) * arm_radius) +
	             sin(max_angle) * arm_radius;

	origin_offset = maximum_degrees_of_freedom == 180 ? 0 : arm_inset / sin(180 - maximum_degrees_of_freedom);

	echo("shelf_width_with_legs:", shelf_width_with_legs);

	// color([ 1, 0, 0 ]) translate(rotational_origin_bottom)
	// translate([ shelf_width_with_legs + 5, 0, 0 ])
	// rotate([ 0, -90, 0 ])
	// cylinder(shelf_width_with_legs + 10, 0.4, 0.4);

	// echo("arm_inset:");
	// echo(arm_inset);
	echo("origin_offset:");
	echo(origin_offset);
	rotational_origin_top = [ 0, shelf_depth - arm_inset, total_height - arm_inset ];
	rotational_origin_bottom = [ 0, arm_offset, arm_inset ];

	// shelf_horizontal_clearance = 10; // todo: figure this out
	shelf_horizontal_clearance = sqrt(shelf_depth ^ 2 + total_height ^ 2) - shelf_depth;
	// echo(shelf_depth);
	// echo(shelf_horizontal_clearance);

	shelf_distance = shelf_depth + shelf_horizontal_clearance;

	mounting_bracket_side_wall_thickness = wall_width * leg_offset;
	mounting_bracket_thickness = 4;
	// echo(shelf_distance);

	// echo(shelf_rows);
	// echo(first_shelf_offset);
	total_depth = (shelf_distance * (shelf_rows + 1)) - first_shelf_offset;

	module thread(diameter, rod_length, thread_length)
	{
		RodEnd(diameter, rod_length, thread_length, spring_bolt_thread_size, spring_bolt_thread_pitch);
	}

	module shelf()
	{

		// function rotate_point(x, y, angle) = [ x * cos(angle) - y * sin(angle), x * sin(angle) + y * cos(angle) ];

		// translate([ -leg_offset, shelf_depth, total_height - tan(max_angle) * arm_radius ])
		// rotate([ -maximum_degrees_of_freedom, -90, 0 ])
		// translate([ -1, -shelf_depth / 4 ])

		difference() // cut out slots for items
		{
			difference() // cut out holes in legs
			{

				union() // make box with legs
				{
					// rounded_cube(shelf_width, shelf_depth, shelf_height, 0);

					axes();

					// shelf walls
					// for (i = [0:1])
					// {
					// cutout_triangle_width = shelf_depth - shelf_leg_width * 2;
					// cutout_triangle_height = total_height - shelf_leg_depth;

					// scale_x =
					// y_offset = shelf_height;
					// x_offset = shelf_leg_width;
					// x =
					// echo(shelf_height);
					// echo(shelf_depth - shelf_leg_width);
					// echo(total_height);

					slope = (total_height - shelf_height) / (shelf_depth - shelf_leg_depth);
					// echo("eat my butt nugget");
					// echo(slope);
					radians = atan(slope);
					// echo(radians);

					x_offset = tan(radians);

					// translate([ -leg_offset, shelf_depth, 0 ])
					// translate([])

					points = [
						[ shelf_depth, shelf_height, 100 ],
						[ wall_width + arm_offset, shelf_height, 0 ],
						// [ wall_width, shelf_height, 0 ],
						[ 8, shelf_height, 0 ],
						// [ 0, shelf_height, 8 ],
						[ 0, total_height, 0 ],
						[ shelf_depth, total_height, 0 ],
					];
					echo("points:", points);
					// inner shelf curved cutout
					// translate([ wall_width, 0, leg_offset ])
					// rotate([ 90, 0, 90 ])
					// color([ 0.8, 0.8, 0.9 ]) polyRoundExtrude(
					//     points,
					//     shelf_width - wall_width * 2, item_sides_corner_radius, item_sides_corner_radius);

					difference() // cut an angle in the supports
					{

						// full shelf curved cutout
						translate([ -leg_offset, 0, 0 ])
						rotate([ 90, 0, 90 ])
						polyRoundExtrude(
						    [
							    [ 0, 0, 2 ],
							    [ 0, shelf_height, 8 ],
							    [ arm_offset - arm_radius, shelf_height, 100 ],
							    [ shelf_depth - (shelf_depth - arm_offset + arm_radius) / 2, total_height / 2, 100 ],
							    [ shelf_depth - arm_width, total_height, 0 ],
							    [ shelf_depth, total_height, 0 ],
							    [ shelf_depth, 0, 0 ],
						    ],
						    shelf_width_with_legs, 0, 0);
					}
				}

				if (cut_out_front_corner)
				{
					translate([ 0, 0, sin(max_angle) * (arm_offset - sin(max_angle) * arm_radius) ])
					rotate([ 180 + max_angle, 0, 0 ])
					translate([ -leg_offset - 1, 0, 0 ])
					color([ 1, 0, 0 ]) cube([ shelf_width_with_legs + 2, 10, 20 ]);
				}

				if (cut_out_back_corner)
				{
					rotate([ 180 - maximum_degrees_of_freedom, 0, 0 ])
					translate([ -10, 10, -arm_width * 2 - total_height ])
					color([ 1, 0, 0 ])
					    cube([ shelf_width_with_legs + 20, tan(max_angle) * total_height * 2, total_height ]);

					translate([ -arm_thickness + 1, shelf_depth, lip_height ])
					rotate([ -90, 90, -90 ])
					cylinder(shelf_width_with_legs + 2, d = (shelf_depth + total_height) / 3);
				}

				// polyRoundExtrude([[wall_width, shelf_height, 0], [wall_width + 1,shelf_height
				// + 1, 0],
				//                   [0, shelf_depth, 0]],
				//                  shelf_width_with_legs, 0, 0);
				// linear_extrude(5000) polygon([ [ 0, 0 ], [ 0, 5 ], [ 5, 5 ] ]);
			}

			translate([ wall_width, wall_width, wall_width ])
			{

				for (i = [0:shelf_columns - 1])
				{

					translate([ (wall_width + item_width) * i, 0, 0 ])
					item();

					// angular_spacing = 360 / item_sides;
					// interior_angle = (180 * (item_sides - 2)) / item_sides;

					// center = [ item_width / 2, item_height / 2 ];
					// side_length = item_radius * sin(angular_spacing) * 2;

					// circum_radius = item_sides == 3   ? side_length / (2.2 / sqrt(3))
					//                 : item_sides == 4 ? side_length / (2 * sin(180 / item_sides))
					//                                   : item_radius;

					// poly_points = [
					// 	for (i = [0:item_sides - 1])[sin(angular_spacing * i + interior_angle / 2) * circum_radius,
					// 	                             cos(angular_spacing * i + interior_angle / 2) * circum_radius,
					// 	                             item_sides_corner_radius] +
					// 	    [ item_radius, item_radius, 0 ],
					// ];

					// polyPoints = poly_points;

					// echo("polyPoints:", polyPoints);

					// // rotate_axis = item_sides == 3 ? [ item_radius, item_radius ] : [ item_radius, item_radius ];
					// rotate_axis = [ item_radius, item_radius ];
					// // rotate_axis = [ 0, 0 ];

					// translate([
					// 	(wall_width + item_width) * i,
					// 	// (item_sides == 3 && i % 2 != 0) ? -2 : 0,
					// 	0, 0
					// 	// item_radius - circum_radius, 0
					// ])

					// // translate([
					// // 	// (item_sides % 2 != 0 && i % 2 == 0) ? -(shelf_columns * (item_width + wall_width)) : 0,
					// // 	(item_sides == 3 && i % 2 == 0) ? -100 : 0,
					// // 	// (item_sides % 2 != 0 && i % 2 != 0) ? -item_width - wall_width : 0,
					// // 	0, 0,
					// // 	// wall_width + (item_sides % 2 != 0 && i % 2 != 0) ? -item_width - wall_width : 0,
					// // 	wall_width
					// // ])

					// translate([
					// 	0, item_sides == 3 ? ((circum_radius - item_radius - wall_width) * (i % 2 == 0 ? -1 : 1)) : 0, 0
					// ])
					// rotate_around_axis(0, 0, (item_sides % 2 != 0) ? (interior_angle / 2) + (i % 2 != 0 ? 180 : 0) :
					// 0,
					//                    rotate_axis)

					//     rotate_around_axis(0, 0, (item_sides % 2 == 0 && item_sides % 4 != 0) ? angular_spacing / 2 :
					//     0,
					//                        rotate_axis) color([ 0, 0.8, 0.1 ])
					//         polyRoundExtrude(polyPoints, item_height, item_bottom_corner_radius,
					//                          item_bottom_corner_radius);

					// color([ 1, 0, 0 ]) translate([ rotate_axis[0], rotate_axis[1], -50 ])
					// cylinder(100, d = 1);

					cylinder_height = sqrt(item_height ^ 2 + item_width ^ 2);
					// circular cutout on bottom and back of each item space
					shelf_angle = shelf_depth / (total_height - lip_height) * 180;
					translate([ item_radius, item_width / 8, 1 ])
					rotate([ shelf_angle, 0, 0 ])
					translate([ i * (item_width + wall_width), -item_width / 4, -cylinder_height / 2 ])
					cylinder(cylinder_height * 2, item_width / 2, item_width / 3.5);
				}

				// not this
				// attempt at polygons
				// polyRoundExtrude(
				//     [
				// 	    [ 0, 0, item_sides_corner_radius ], [ 0, item_width, item_sides_corner_radius ],
				// 	    [ item_width, item_width, item_sides_corner_radius ],
				// 	    [ item_width, 0, item_sides_corner_radius ]
				//     ],
				//     item_height, item_sides_corner_radius);
			}
		}

		if (show_dummy_items)
		{
			for (i = [0:shelf_columns - 1])
				translate([ i * (item_width + wall_width) + wall_width, wall_width, wall_width ])
			color([ 1, 0.7, 0.7 ]) item();
			// rounded_cube(item_width, item_width, item_height, [ item_bottom_corner_radius, item_sides_corner_radius
			// ]);
		}

		// [for (i = [0:item_sides]) {
		// 	angle = 360 / item_sides * i;
		// 	[ cos(angle) * item_width, sin(angle) * item_width ];
		// }];

		// cube([ 5, 5, 5 ]);
		// polyhedron([ [ 0, 0 ], [ 0, 5 ], [ 5, 5 ] ], 4)

		// bar_width =
	}

	module item()
	{

		angular_spacing = 360 / item_sides;
		interior_angle = (180 * (item_sides - 2)) / item_sides;

		center = [ item_width / 2, item_height / 2 ];
		side_length = item_radius * sin(angular_spacing) * 2;

		circum_radius = item_sides == 3   ? side_length / (2.2 / sqrt(3))
		                : item_sides == 4 ? side_length / (2 * sin(180 / item_sides))
		                                  : item_radius;

		polyPoints = [
			for (i = [0:item_sides -
			            1])[sin(angular_spacing * i + interior_angle / 2) * circum_radius,
			                cos(angular_spacing * i + interior_angle / 2) * circum_radius, item_sides_corner_radius] +
			    [ item_radius, item_radius, 0 ],
		];

		rotate_axis = [ item_radius, item_radius ];

		translate([ 0, item_sides == 3 ? ((circum_radius - item_radius - wall_width) * (i % 2 == 0 ? -1 : 1)) : 0, 0 ])
		rotate_around_axis(0, 0, (item_sides % 2 != 0) ? (interior_angle / 2) + (i % 2 != 0 ? 180 : 0) : 0, rotate_axis)

		    rotate_around_axis(0, 0, (item_sides % 2 == 0 && item_sides % 4 != 0) ? angular_spacing / 2 : 0,
		                       rotate_axis) color([ 0, 0.8, 0.1 ])
		        polyRoundExtrude(polyPoints, item_height, item_bottom_corner_radius, item_bottom_corner_radius);
	}

	module shelves()
	{
		// create shelf bodies
		for (i = [0:shelf_rows - 1])
		{

			distance_from_rotation_origin = ((i + 1) * shelf_distance) - first_shelf_offset;

			translate([
				0, distance_from_rotation_origin * sin(render_angle + 90),
				distance_from_rotation_origin * cos(render_angle + 90)
			])

			// translate([ 0, ((i + 1) * shelf_distance) - first_shelf_offset, 0 ])
			shelf(i);
		}
	}

	module axes()
	{

		module axis()
		{

			for (i = [0:1])
			{
				rotate([ 0, 90, 0 ])
				translate([
					0, 0,
					-wall_width - arm_thickness - bolt_arm_clearance + i * (shelf_width + arm_thickness + wall_width)
				])
				color([ 5, 2, 4 ]) cylinder(arm_thickness + bolt_arm_clearance * 2 + wall_width, d = axis_size);

				rotate([ 0, 90, 0 ])
				translate([
					0, 0,
					i == 0 ? -leg_offset - bolt_arm_clearance * 2 - arm_thickness * 2
					       : -leg_offset + shelf_width_with_legs + bolt_arm_clearance * 2 + arm_thickness
					// -wall_width - arm_thickness - bolt_arm_clearance + i * (shelf_width + arm_thickness + wall_width)
				])
				color([ .5, .2, .4 ]) cylinder(arm_thickness, r = arm_radius);
			}
		}

		translate(rotational_origin_bottom)
		axis();
		translate(rotational_origin_top)
		axis();
	}

	module boltMound()
	{
		// union()
		{

			h = (arm_width + bolt_arm_clearance) * 1.2;
			r = arm_radius;
			d = spring_bolt_thread_size + 1;

			difference()
			{

				translate([ 0, 0, -wall_width ])
				color([ 1, 0, 0 ]) cylinder(h, arm_radius * 1.3, spring_bolt_thread_size + 1, center = true);

				translate([ 0, 0, -wall_width - h / 2 ])
				cylinder(h + 10, d = d);
			}

			translate([ 0, 0, -wall_width - h / 2 ])
			// RodEnd(d, h, h, spring_bolt_thread_size, 0.5);
			thread(d, h, h);
		}
	}

	module mountingBracket()
	{
		// translate([ 0, 0, total_height ])
		// rounded_cube(shelf_width_with_legs, shelf_depth, total_height, [ 0, 0, 2, 2, 2, 2 ]);

		module boltMounds()
		{

			// left side cone
			translate([
				arm_thickness + bolt_arm_clearance + shelf_width_with_legs,
				cos(max_angle) * (total_height + mounting_bracket_extra_height) - arm_radius / 2,
				total_height - arm_radius * 1.5
			])
			rotate([ 0, 100, 20 ])
			boltMound();

			// right side cone
			translate([
				-arm_thickness - wall_width - leg_offset,
				cos(max_angle) * (total_height + mounting_bracket_extra_height) - arm_radius / 2,
				total_height - arm_radius * 1.5
			])
			rotate([ 0, -100, -20 ])
			boltMound();
		}

		difference()
		{
			union()
			{

				translate([ 0, 0, mounting_bracket_extra_height ])
				translate([ -leg_offset, 0, total_height ])
				rotate([ 0, 90, 0 ])
				rounded_cube(total_height + mounting_bracket_extra_height, shelf_depth, shelf_width_with_legs,
				             [ 0, 0, 0, min(shelf_depth, total_height), 6, 0, 0 ]);

				axes();
				boltMounds();
			}

			translate([
				0, sin(render_angle) * mounting_bracket_extra_height, -cos(render_angle) * mounting_bracket_extra_height
			])
			translate([ leg_offset, mounting_bracket_thickness, total_height - mounting_bracket_thickness ])
			rotate([ 0, 90, 0 ])
			rounded_cube(total_height * 2, shelf_depth,
			             shelf_width_with_legs - (mounting_bracket_side_wall_thickness * 2),
			             [ total_height / 2, total_height / 2, 0, 0, 15, 0 ]);

			rotate([ 180 - maximum_degrees_of_freedom, 0, 0 ])
			translate([ -10, 10, -arm_width * 2 - total_height ])
			color([ 1, 0, 0 ]) cube([ shelf_width_with_legs + 20, tan(max_angle) * total_height * 2, total_height ]);
		}
	}

	top_spring_hole_location = [ -arm_offset - arm_width, total_height - arm_width ];

	distance_to_arm_top = top_spring_hole_location[1] - arm_width;

	module armThread()
	{

		union()
		{
			difference()
			{
				color([ 0.9, 0.4, 0.4 ])
				    cylinder(arm_thickness * 3, d = spring_bolt_thread_size + 2, spring_bolt_thread_size + 2);
				translate([ 0, 0, -1 ])
				color([ 0.5, 0.1, 0.1 ]) cylinder(arm_thickness * 4, d = spring_bolt_thread_size + 2);
			}
			color([ 0, 1, 0 ]) thread(spring_bolt_thread_size + 2, arm_thickness * 3, arm_thickness * 3);
		}
	}

	module arms()
	{
		module arm()
		{
			color([ .2, .6, 1 ]) rotate([ 90, 180, 270 ])
			rounded_cube(total_depth - shelf_horizontal_clearance - shelf_depth + arm_width, arm_width, arm_thickness,
			             [ 0, 0, arm_width / 2 ]);
		}

		module armSide()
		{
			origin1 = [
				-arm_thickness - 2,
				arm_offset,
				arm_radius,
			];

			for (i = [0:1])
			{
				difference()
				{

					// top
					union()
					{

						rotate_around_axis(-render_angle, 0, 0,
						                   i == 0 ? rotational_origin_top : rotational_origin_bottom)
						    translate(i == 0 ?
						                     // [ rotational_origin_top[0], rotational_origin_top[1] + arm_inset -
						                     // arm_width, rotational_origin_top[2] + arm_inset ]
						                  rotational_origin_top + [ 0, arm_inset - arm_width, arm_inset ]
						                     : rotational_origin_bottom + [ 0, -arm_inset, arm_inset ])
						arm();

						// translate([0,0,])
						// 			rotate([ 0, 90, 0 ])
						// 			boltMound();

						// if (i == 1 && j == 1)
						// {
						// translate([ -shelf_width_with_legs, 0, 0 ])
						// translate([ 0, leg_offset + arm_width, 0 ])
						// rotate([ 0, -180, 180 ])

						// translate([ 0, 0, 0 ])
						// rotate([ 0, -90, 0 ])
						// translate([ -arm_thickness - bolt_arm_clearance, arm_offset + arm_radius, 0 ])
						// rotate([ 0, j == 1 ? 180 : 0, 0 ])
						// armThread();
						// }
					}

					for (j = [0:shelf_rows])
					{
						distance_from_rotation_origin =
						    (j * shelf_distance) - first_shelf_offset + (j == 0 ? first_shelf_offset : 0);

						translate([
							0, distance_from_rotation_origin * sin(render_angle + 90),
							distance_from_rotation_origin * cos(render_angle + 90)
						])
						// translate(origin1 + [
						// 	i * sec(render_angle) * distance_between_rotational_origins,
						// 	i * csc(render_angle) * distance_between_rotational_origins, 0
						// ]);
						translate(i == 0 ? rotational_origin_top : rotational_origin_bottom)
						rotate([ 0, 90, 0 ])
						translate([ 0, 0, -15 ])
						color([ 0, 0, 1 ]) cylinder(30, d = axis_size + bolt_arm_clearance * 2);
					}
				}
			}
		}

		for (i = [0:1])
		{
			translate([ -leg_offset - bolt_arm_clearance, 0, 0 ])
			armSide();

			union()
			{

				vertical_distance_between_spring_threads = top_spring_hole_location[0] - arm_width / 2;

				horizontal_distance_between_spring_threads =
				    arm_radius + sqrt(min_spring_distance ^ 2 + vertical_distance_between_spring_threads);

				difference()
				{

					translate([ shelf_width + leg_offset + arm_thickness + bolt_arm_clearance, 0, 0 ])
					armSide();

					translate([
						-1 - arm_thickness - bolt_arm_clearance,
						arm_offset + horizontal_distance_between_spring_threads, +arm_radius
					])
				rotate_around_axis(-render_angle, 0, 0, rotational_origin_bottom) translate([
					rotate([ 0, 90, 0 ])
					cylinder(shelf_width_with_legs + bolt_arm_clearance * 2 + arm_thickness * 2 + 2,
					         d = spring_bolt_thread_size + 2);
				}

				rotate_around_axis(-render_angle, 0, 0, rotational_origin_bottom) translate([
					i == 1 ? shelf_width_with_legs : -leg_offset - bolt_arm_clearance,
					arm_width + horizontal_distance_between_spring_threads, (spring_bolt_thread_size + 2)
					// arm_width - spring_bolt_thread_size * 2
				])
				rotate([ 0, 90 * (i == 1 ? 1 : -1), 0 ])
				armThread();
			}
		}
	}

	module tray()
	{
		shelves();
		mountingBracket();
		arms();
	}

	tray();

	echo("Height collapsed:", total_height + mounting_bracket_extra_height);
	echo("Length collapsed (Height at 90deg rotation):", total_depth);
	echo("Width:", shelf_width_with_legs + arm_width * 2);
	echo("Total distance protruding from mounting bracket when fully open:", cos(max_angle) * total_depth + arm_offset);
}

hideawayShelves();
