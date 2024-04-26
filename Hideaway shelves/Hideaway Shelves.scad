$fn = 12 * 10;
// include <Round-Anything/polyround.scad>
include <Rounded_Cube.scad>
use <threads-scad/threads.scad>
include <rotate_around_axis.scad>
// all units in mm or deg

item_height = 26;
item_width = 37; // include a small amount of padding for comfort, I like 1mm

shelf_rows = 3;
shelf_columns = 5;

maximum_degrees_of_freedom = 120;

item_sides = 4;
item_sides_corner_radius = 6;

min_arm_width = 4;
arm_thickness = 2.4;

render_angle_degree = 60;
items_bottom_corner_radius = 0;

axis_size = 5;

print_in_place = false;
spring_bolt_thread_size = 3;
spring_bolt_thread_pitch = 0.5;

axis_bolt_thread_size = 2;
axis_bolt_thread_pitch = 0.5;
axis_bolt_head_diameter = 4;
axis_bolt_head_depth = 2;

shelf_to_attach_spring = 2;
attach_spring_above_shelf = true;

mounting_bracket_target_height = 31.75;

mounting_screw_size = 4;
mounting_screw_head_size = 7;

show_dummy_items = false;

wall_width = 1.6;
inner_divider_width = wall_width;
lip_height = 5;
item_bottom_corner_radius = 0;

bolt_arm_clearance = 0.2; // for preventing arms from sticking to joints when printing-in-place

first_shelf_offset = -10;
cut_out_back_corner = true;
cut_out_front_corner = false;
cut_out_finger_holes = true;
cut_out_back_cylinder = true;
trim_arms = false;

axis_only = false;
arms_only = true;
bracket_only = false;
shelf_only = false;

// do not edit values beyond this line

module hideawayShelves()
{

	render_angle = max(0, min(render_angle_degree, maximum_degrees_of_freedom));

	total_height = wall_width + item_height;

	shelf_width = wall_width + shelf_columns * (wall_width + item_width);
	shelf_height = wall_width + lip_height;
	shelf_depth = wall_width * 2 + item_width;

	item_radius = item_width / 2;

	max_arm_width = min(total_height, shelf_depth) / 2 - bolt_arm_clearance / 4;
	max_angle = 180 - maximum_degrees_of_freedom;
	item_sides = max(3, item_sides); // lower will cause infinities and zeroes

	mounting_bracket_extra_height = mounting_bracket_target_height - total_height;

	function cot(a) = 1 / tan(a);
	function sec(a) = 1 / sin(a);
	function csc(a) = 1 / cos(a);

	arm_radius =
	    min((tan(max_angle) * shelf_depth - total_height) / (tan(max_angle) - 1 + 3 * sqrt(1 + tan(max_angle) ^ 2)),
	        shelf_depth / 4, total_height / 4);

	arm_width = arm_radius * 2;

	bolt_hole_size = arm_width / 2;
	bolt_head_size = arm_width;
	bolt_head_taper_angle = 0;

	shelf_leg_width = shelf_depth / 4;
	shelf_leg_depth = shelf_leg_width / 3;

	leg_offset = shelf_leg_depth - wall_width;
	shelf_width_with_legs = leg_offset + wall_width * 2 + shelf_width;

	arm_inset = arm_width / 2;
	arm_offset = arm_width / tan(max_angle) - cot(max_angle) * (arm_radius - cos(max_angle) * arm_radius) +
	             sin(max_angle) * arm_radius;

	origin_offset = maximum_degrees_of_freedom == 180 ? 0 : arm_inset / sin(180 - maximum_degrees_of_freedom);

	rotational_origin_top = [ 0, shelf_depth - arm_inset, total_height - arm_inset ];
	rotational_origin_bottom = [ 0, arm_offset, arm_inset ];

	shelf_horizontal_clearance = sqrt(shelf_depth ^ 2 + total_height ^ 2) - shelf_depth;

	shelf_distance = shelf_depth + shelf_horizontal_clearance;

	mounting_bracket_side_wall_thickness = wall_width * leg_offset;
	mounting_bracket_thickness = 4;

	total_depth = (shelf_distance * (shelf_rows + 1)) - first_shelf_offset;
	arm_length = total_depth - shelf_horizontal_clearance - shelf_depth + arm_width;

	stub_length = axis_bolt_head_depth;

	module thread(diameter, rod_length, thread_length)
	{
		RodEnd(diameter, rod_length, thread_length, spring_bolt_thread_size, spring_bolt_thread_pitch);
	}

	module shelf()
	{

		// function moveToTopOrigin(item) = translate(rotational_origin_top);
		// function moveToBottomOrigin(item) = translate(rotational_origin_top);

		if (print_in_place || !shelf_only)
			axes();

		// translate([
		// 	rotational_origin_top[0] - leg_offset - axis_bolt_head_depth, rotational_origin_top[1],
		// 	rotational_origin_top[2]
		// ])

		// moveToTopOrigin() cylinder(shelf_leg_width, r = axis_size);

		difference() // cut out slots for items
		{
			difference() // cut out holes in legs
			{

				union() // make box with legs
				{

					slope = (total_height - shelf_height) / (shelf_depth - shelf_leg_depth);
					radians = atan(slope);

					x_offset = tan(radians);

					points = [
						[ shelf_depth, shelf_height, 100 ],
						[ wall_width + arm_offset, shelf_height, 0 ],
						[ 8, shelf_height, 0 ],
						[ 0, total_height, 0 ],
						[ shelf_depth, total_height, 0 ],
					];

					// cut an angle in the supports

					// full shelf curved cutout
					translate([ -leg_offset, 0, 0 ])
					rotate([ 90, 0, 90 ])
					color([ 0, 0, 1 ]) polyRoundExtrude(
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

				// innner shelf curved cutout
				translate([ item_radius, 0, 0 ])
				rotate([ 90, 0, 90 ])
				color([ 0, 0.5, 0.5 ]) polyRoundExtrude(
				    [
					    [ 0, total_height, 2 ],
					    [ 0, shelf_height, 8 ],
					    [ arm_offset - arm_radius, shelf_height, 75 ],
					    [ shelf_depth - (shelf_depth - arm_offset + arm_radius) / 2, total_height / 2, 75 ],
					    [ shelf_depth - wall_width, total_height, 0 ],
				    ],
				    shelf_width - item_width, 0, 0);

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

					if (cut_out_back_cylinder)
					{
						translate([ -arm_thickness - bolt_arm_clearance * 2, shelf_depth, lip_height ])
						rotate([ -90, 90, -90 ])
						cylinder(shelf_width_with_legs + leg_offset, d = (shelf_depth + total_height) / 3);
					}
				}
			}

			translate([ wall_width, wall_width, wall_width ])
			{
				for (i = [0:shelf_columns - 1])
				{
					translate([ leg_offset / 2 + (wall_width + item_width) * i, 0, 0 ])
					item();

					if (cut_out_finger_holes)
					{

						// circular cutout on bottom and back of each item space
						cylinder_height = sqrt(item_height ^ 2 + item_width ^ 2);
						shelf_angle = -90 - shelf_depth / (total_height - lip_height) * 180;
						translate([ item_radius, item_width / 8, 1 ])
						rotate([ shelf_angle, 0, 0 ])
						translate([ i * (item_width + wall_width), -item_width / 4, -cylinder_height / 4 ])
						hull()
						{
							cylinder(cylinder_height, item_width / 3, item_width / 3);
							translate([ 0, 0, cylinder_height * 1.5 ])
							cylinder(cylinder_height, item_width / 2, item_width / 3, $fn = 6);
						}
					}
				}
			}

			testCutout();
		}

		module testCutout()
		{
			// translate([ shelf_width + leg_offset / 2, 0, 0 ])
			translate([ shelf_width + leg_offset, 0, 0 ])
			mirror([ 1, 0, 0 ]) cutoutSide();

			cutoutSide();
		}
		// cutoutSide();

		// translate([ shelf_width + leg_offset, 0, 0 ])
		// mirror([ 1, 0, 0 ]) cutoutSide();
		// testCutout();

		if (show_dummy_items)
		{
			for (i = [0:shelf_columns - 1])
				translate([ i * (item_width + wall_width) + wall_width + leg_offset / 2, wall_width, wall_width ])
			color([ 1, 0.7, 0.7 ]) item();
		}

		stubPair();
	}

	module stubPair()
	{

		translate([ -leg_offset, 0, 0 ])

		union()
		{
			translate(rotational_origin_top)
			stub();
			translate(rotational_origin_bottom)
			stub();
		}

		translate([
			// stub_length, // + shelf_width_with_legs,
			shelf_width_with_legs - leg_offset + stub_length,
			0,
			0,
		])

		union()
		{
			translate(rotational_origin_top)
			stub();
			translate(rotational_origin_bottom)
			stub();
		}
	}

	module stub()
	{

		rotate([ 0, -90, 0 ])
		difference()
		{
			cylinder(stub_length, d = axis_size);
			if (!print_in_place)
				color("red") cylinder(axis_bolt_head_depth, d = axis_bolt_thread_size + 1);
		}
	}

	module cutoutSide()
	{
		translate(rotational_origin_top)
		stubCutout();

		translate(rotational_origin_bottom)
		stubCutout();
	}

	module stubCutout()
	{
		rotate([ 0, 90, 0 ])
		// translate([ 0, 0, axis_bolt_head_depth * 6 ])
		translate([ 0, 0, 0 ])
		color("orange") cylinder(axis_bolt_head_depth * 8, d = axis_bolt_head_diameter);

		// translate([ 0, 0, -shelf_leg_width / 2 ])

		echo("shelf_leg_width:", shelf_leg_width);
		translate([ axis_bolt_head_depth, 0, 0 ])
		rotate([ 0, -90, 0 ])
		color([ 0.2, 0.6, 0.9 ]) cylinder(shelf_leg_width, d = axis_bolt_thread_size + 1);
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
		for (i = [0:shelf_only == true ? 0 : shelf_rows - 1])
		{

			distance_from_rotation_origin = ((i + 1) * shelf_distance) - first_shelf_offset;

			translate([
				0, distance_from_rotation_origin * sin(render_angle + 90),
				distance_from_rotation_origin * cos(render_angle + 90)
			])

			shelf(i);
		}
	}

	length = arm_thickness + bolt_arm_clearance * 2 + wall_width;
	diameter = axis_size;

	module axis(i)
	{
		offset = arm_thickness + bolt_arm_clearance * 2;
		translate([ -leg_offset - offset + i * (shelf_width_with_legs + offset * 2 + arm_thickness), 0, 0 ])
		rotate([ 0, -90, 0 ])
		difference()
		{
			cylinder(arm_thickness, r = arm_radius);

			if (!print_in_place)
			{
				translate([ 0, 0, arm_thickness * i ])
				color("yellow") cylinder(arm_thickness - 0.4, d = axis_size);
			}
		}

		if (!print_in_place)
		{
			length = (arm_thickness + bolt_arm_clearance) * 2 - axis_bolt_head_depth;
			translate([
				i == 0 ? -leg_offset - (arm_thickness + bolt_arm_clearance) * 2 + 0.4
				       : shelf_width + (arm_thickness + bolt_arm_clearance) * 2 - 0.4,

				// 0,
				0,
				0,
			])
			rotate([ 0, 90, 0 ])
			color("red") RodEnd(axis_size, length - 0.4, length, axis_bolt_thread_size, axis_bolt_thread_pitch);
		}

		// module rotator()
		// {
		// 	if (!threaded)
		// 	{
		// 		color([ .5, .2, .6 ]) cylinder(length, d = diameter);
		// 	}
		// 	else
		// 	{
		// 		RodEnd(diameter, length, length, spring_bolt_thread_size, spring_bolt_thread_pitch);
		// 	}
		// }

		// rotate([ 0, 90, 0 ])
		// translate([
		// 	0,
		// 	0,
		// 	-wall_width - arm_thickness - bolt_arm_clearance + i * (shelf_width_with_legs + arm_thickness) - wall_width,
		// ])

		// rotator();

		// rotate([ 0, 90, 0 ])
		// translate([
		// 	0, 0,
		// 	i == 0 ? -leg_offset - bolt_arm_clearance * 2 - arm_thickness * 2
		// 	       : -leg_offset + shelf_width_with_legs + bolt_arm_clearance * 2 +
		// 	arm_thickness
		// ])
		// color([ .5, .4, .4 ]) cylinder(arm_thickness, r = arm_radius);
	}

	module axes()
	{

		for (i = [0:1])
		{
			translate(rotational_origin_bottom)
			axis(i);

			translate(rotational_origin_top)
			axis(i);
		}
	}

	mound_height = (arm_width + bolt_arm_clearance) * 1.2;

	module boltMound()
	{

		h = mound_height;
		r = arm_radius;
		d = spring_bolt_thread_size + 1;

		difference()
		{

			translate([ 0, 0, -wall_width ])
			color([ 1, 0, 0 ]) cylinder(h, arm_radius, spring_bolt_thread_size + 1, center = true);
			translate([ 0, 0, -wall_width - h / 2 ])
			cylinder(h + 10, d = d);
		}

		translate([ 0, 0, -wall_width - h / 2 ])
		thread(d, h, h);
	}

	module mountingBracket()
	{
		// translate([ 0, 0, total_height ])
		// rounded_cube(shelf_width_with_legs, shelf_depth, total_height, [ 0, 0, 2, 2, 2, 2 ]);

		if (print_in_place || !bracket_only)
		{
			axes();
		}

		module screwHole()
		{
			translate([ 0, 10, 0 ])
			union()
			{
				color([ 1, 0, 0 ]) cylinder(total_height + mounting_bracket_extra_height, d = mounting_screw_size);

				// translate([ 0, 0, total_height - 8 ])
				// color([ 0, 1, 0 ])
				//     cylinder(mounting_bracket_thickness * 2, d = mounting_screw_size, mounting_screw_head_size);

				translate([ 0, 0, total_height - 12 ])
				color([ 0, 1, 0 ]) cylinder(mounting_bracket_thickness * 2, r = mounting_screw_head_size,
				                            r = mounting_screw_head_size * 1.2);
			}
		}

		module screwHolePair()
		{

			end_screws_distance = max(max(mounting_bracket_thickness, shelf_width / 8), 10);

			translate([ end_screws_distance, shelf_depth / 2, 4 ])
			screwHole();

			translate([ shelf_width - end_screws_distance, shelf_depth / 2, 4 ])
			screwHole();
		}

		module boltMounds()
		{

			translate([
				0,
				// sin(max_angle) * (total_height + mounting_bracket_extra_height),
				sqrt(mound_height ^ 2 + arm_radius ^ 2) - arm_radius,
				// mound_height,
				// arm_radius * 1.1,
				total_height - mounting_bracket_extra_height - arm_radius,
			])
			union()
			{
				rotation = [ 0, 100, 00 ];
				// right side cone
				translate([ shelf_width + leg_offset + mound_height / 4, 0, 0 ])
				rotate(rotation)
				boltMound();

				// left side cone
				translate([ -mound_height / 4, 0, 0 ])
				rotate(rotation * -1)
				boltMound();
			}
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
				stubPair();
				boltMounds();

				if (print_in_place || !bracket_only)
				{
					axes();
				}

				// axes();
			}

			rotate([ 180 - maximum_degrees_of_freedom, 0, 0 ])
			translate([ -10, 10, -arm_width * 2 - total_height ])
			color([ 1, 0, 0 ]) cube([ shelf_width_with_legs + 20, tan(max_angle) * total_height * 2, total_height ]);
			screwHolePair();
			cutoutSide();

			translate([
				0, sin(render_angle) * mounting_bracket_extra_height, -cos(render_angle) * mounting_bracket_extra_height
			])
			translate([
				mounting_bracket_thickness - leg_offset, mounting_bracket_thickness, total_height -
				mounting_bracket_thickness
			])
			rotate([ 0, 90, 0 ])
			color([ 1, 0, 0 ])
			    rounded_cube(total_height * 2, shelf_depth,
			                 shelf_width_with_legs - mounting_bracket_side_wall_thickness * 2 - wall_width * 2,
			                 [ total_height / 2, total_height / 2, 0, 0, 15, 0 ]);

			rotate([ 90, 0, 0 ])
			translate([
				0, (-total_height - mounting_bracket_extra_height) / 2,
				-total_height - mounting_bracket_extra_height - 2
			])
			screwHolePair();

			// translate([ shelf_width_with_legs, 0, 0 ])
			translate([ shelf_width, 0, 0 ])
			mirror([ 1, 0, 0 ]) cutoutSide();
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
				    cylinder(arm_thickness * 3, arm_width / 4, d1 = max(spring_bolt_thread_size + 4, arm_width / 1.5),
				             d2 = spring_bolt_thread_size + 2);
				translate([ 0, 0, -1 ])
				color([ 0.5, 0.1, 0.1 ]) cylinder(arm_thickness * 4, d = spring_bolt_thread_size + 2);
			}
			color([ 0, 1, 0 ]) thread(spring_bolt_thread_size + 2, arm_thickness * 3, arm_thickness * 3);
		}
	}

	module arms()
	{

		shelf = min(shelf_to_attach_spring, shelf_rows);
		min_spring_length =
		    shelf * shelf_distance - first_shelf_offset +
		    ((attach_spring_above_shelf || shelf == shelf_rows) ? -arm_width - spring_bolt_thread_size * 2
		                                                        : arm_radius); // 80;

		vertical_distance_between_spring_threads = top_spring_hole_location[0] - arm_width / 2;
		horizontal_distance_between_spring_threads =
		    arm_radius + sqrt(min_spring_length ^ 2 + vertical_distance_between_spring_threads);
		// echo("Distance from arm axis to arm spring screw thread: ", min_spring_length);

		module arm()
		{

			starting_points = [
				[ 1, arm_radius, arm_width ],
				// [ -1, arm_radius + shelf_distance - first_shelf_offset, 1 ],
				[ arm_radius / 2, arm_radius + shelf_distance / 2, shelf_distance * 2 ],
			];

			hole_distances = [for (i = [0:shelf_rows - 1]) i * shelf_distance];

			points = concat(
			    [
			      [ -3, -3, 0 ],
			      [ arm_radius, -3, 0 ],
			      [ arm_radius, 0, 0 ],
			      [ 0, 0, arm_width ],
			      starting_points[0],
			      starting_points[1],
			    ],
			    shelf_rows <= 1 ? [] : [
			    	for (i = [1:shelf_rows - 1]) for (j = [0:len(starting_points) - 1]) starting_points[j] +
			    	    [ 0, i * shelf_distance - first_shelf_offset, 0 ],
			    ],
			    [
				    [ 0, arm_length, arm_width ],
				    [ arm_radius, arm_length, 0 ],
				    [ arm_radius, arm_length + 3, 0 ],
				    [ -3, arm_length + 3, 0 ],
			    ]);

			difference()
			{

				color([ .2, .6, 1 ]) rotate([ 90, 180, 270 ])
				rounded_cube(arm_length, arm_width, arm_thickness, [ 0, 0, arm_width / 2 ]);

				if (trim_arms)
				{
					union()
					{
						translate([ arm_thickness - bolt_arm_clearance * 3, 0, 0 ])
						rotate([ 0, -90, 0 ])
						translate([ -arm_width, 0, 0 ])
						color([ 1, 1, 0 ]) polyRoundExtrude(points, 5, 0);

						translate([ -arm_thickness - bolt_arm_clearance, 0, 0 ])
						rotate([ 0, 90, 0 ])
						color([ 1, 0, 0 ]) polyRoundExtrude(points, 5, 0);
					}
				}
			}
		}

		module armSide()
		{
			origin1 = [
				-arm_thickness - 2,
				arm_offset,
				arm_radius,
			];

			// for (i = [0:1])
			{
				difference()
				{

					// top and bottom

					union()
					{

						difference()
						{

							// top
							rotate_around_axis(-render_angle, 0, 0, rotational_origin_top)
							    translate(rotational_origin_top + [ 0, arm_inset - arm_width, arm_inset ])
							arm();
						}

						// if (!arms_only)
						difference()
						{

							// bottom
							rotate_around_axis(-render_angle, 0, 0, rotational_origin_bottom)
							    translate(rotational_origin_bottom + [ 0, -arm_inset, arm_inset ])
							arm();

							rotate_around_axis(-render_angle, 0, 0, rotational_origin_bottom) translate([
								-25 - arm_thickness - bolt_arm_clearance,
								arm_offset + horizontal_distance_between_spring_threads, +arm_radius
							])
							rotate([ 0, 90, 0 ])
							translate([ 0, arm_width / 4 / 2 / 2, 0 ])
							color([ 1, 1, 0.4 ])
							    cylinder(shelf_width_with_legs + bolt_arm_clearance * 2 + arm_thickness * 2 + 50,
							             d = spring_bolt_thread_size + 1);
						}
					}

					for (j = [0:shelf_rows])
					{
						for (k = [0:1])
						{

							distance_from_rotation_origin =
							    (j * shelf_distance) - first_shelf_offset + (j == 0 ? first_shelf_offset : 0);

							translate([
								0, distance_from_rotation_origin * sin(render_angle + 90),
								distance_from_rotation_origin * cos(render_angle + 90)
							])

							translate(k == 0 ? rotational_origin_bottom : rotational_origin_top)
							rotate([ 0, 90, 0 ])
							translate([ 0, 0, -15 ])
							color([ 0, 0, 1 ]) cylinder(30, d = axis_size + bolt_arm_clearance * 2);
						}
					}
				}
			}
		}

		for (i = [0:arms_only ? 0 : 1])
		{
			if (!arms_only || print_in_place)
			{
				translate([ -leg_offset - bolt_arm_clearance, 0, 0 ])
				armSide();
			}

			union()
			{

				translate([ -leg_offset + shelf_width_with_legs + arm_thickness + bolt_arm_clearance, 0, 0 ])
				armSide();

				rotate_around_axis(-render_angle, 0, 0, rotational_origin_bottom) translate([
					i == 1 ? shelf_width_with_legs - leg_offset + bolt_arm_clearance : -leg_offset - bolt_arm_clearance,
					arm_width + horizontal_distance_between_spring_threads, (spring_bolt_thread_size + 2),
					// arm_width - spring_bolt_thread_size * 2
				])
				// translate([
				// 	i * arm_thickness, -arm_radius + (spring_bolt_thread_size + 2),
				// 	arm_radius - (spring_bolt_thread_size + 2)
				// ])
				// translate([ (shelf_width_with_legs + arm_width) * i == 0 ? 1 : -1, 0, 0 ])
				translate([
					(shelf_width_with_legs + bolt_arm_clearance * 2) * (i == 0 ? 1 : -1),
					-arm_radius + (spring_bolt_thread_size + 2),
					arm_radius - (spring_bolt_thread_size + 2),
				])
				rotate([ 0, 90 * (i == 1 ? 1 : -1), 180 ])
				// translate([ -arm_radius + (spring_bolt_thread_size + 2), , 0 ])
				armThread();
			}
		}
	}

	module tray()
	{
		if (axis_only)
			axis(0);
		else
		{
			if (arms_only || shelf_only || bracket_only)
			{

				if (arms_only)
					arms();
				if (shelf_only)
					shelves();
				if (bracket_only)
					mountingBracket();
			}
			else
			{
				arms();
				shelves();
				mountingBracket();
			}
		}
	}

	tray();

	// echo("Height collapsed:", total_height + mounting_bracket_extra_height);
	// echo("Length collapsed (Height at 90deg rotation):", total_depth);
	// echo("Width:", shelf_width_with_legs + arm_width * 2);
	// echo("Total distance protruding from mounting bracket when fully open:", cos(max_angle) * total_depth +
	// arm_offset);
}

hideawayShelves();
