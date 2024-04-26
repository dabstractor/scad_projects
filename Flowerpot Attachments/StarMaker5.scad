/*
    StarMaker5 (Don't ask about the other versions...)
    By Chris Webb (chris@webbtx.com)
    05/10/2021
    Because I like stars and this was a fun excuse to dust off some elemetary geometry.  I'm sure my angle formulas are
   technically incorrect but they work for these two instances (equalateral versus isosceles triangles)

    I couldn't figure out how to put the angle and point generation inside a loop and gave up (I can code in any other
   language, don't judge me, lol.
*/

// The size of the triangle base of the stars points
base_size = 50;
/* A regular star uses equalteral triangles for the points, otherwise use isosceles which is what Texans call a real
 * star
 */
regular_star = false;
// Rounded star = true
rounded = false;
// Rounded star radius for roundness
rounded_radius = 15;
// Linear Extrusion Related Settings
lextrude = true;
lextrude_height = 135;
lextrude_twist = 0;
lextrude_center = false;
lextrude_slices = 100;
lextrude_scale = 1.0;
lextrude_facets = 100;
// Rotation Extrusion Related Settings
rextrude = false;
rextrude_angle = 75;
rextrude_facets = 10;

/* Hidden */
pi = 3.141592654;
RAD = 180 / PI;
pent_sides = 5;

function RegPoly_Radius_From_Side(number_sides, length_side) = (number_sides == 0
                                                                    ? 0
                                                                    : length_side / sin((PI / number_sides) * RAD) / 2);

function RegPoly_Apothem_From_Radius(number_sides, poly_radius) = (number_sides == 0
                                                                       ? 0
                                                                       : poly_radius * cos((PI / number_sides) * RAD));

function RegPoly_Outer_Angle(number_sides) = (number_sides == 0 ? 0 : 360 / number_sides);

function RegPoly_Inner_Angle(number_sides) = (number_sides == 0 ? 0 : 180 / number_sides);

function IsoTri_Height_From_Base_and_Angle(base, angle) = (base == 0 ? 0 : (base / 2) * tan(angle));

function IsoTri_Side_From_Base_and_Angle(base, angle) = (base == 0 ? 0 : base / (2 * cos(angle)));

function IsoTri_Side_From_Base_and_Height(base, height) = (base == 0 ? 0 : sqrt(base * base + height * height));

function Calculate_X_With_Dist_and_Angle(cur_x, dist, angle) = (dist == 0 ? 0 : cur_x + dist * cos(angle));

function Calculate_Y_With_Dist_and_Angle(cur_y, dist, angle) = (dist == 0 ? 0 : cur_y + dist * sin(angle));

function Calculate_XY(cur_x, cur_y, dist,
                      angle) = (dist == 0 ? 0 : [ cur_x + (dist * cos(angle)), cur_y + (dist * sin(angle)) ]);

module Plot_Star(pent_side, regular)
{
	// pent_side is length of one of the 5 sides
	// regular determine if we're using equalateral (true) or isosceles (false) triangles)
	// echo("PlotStar pent_side = ", pent_side, ", regular = ", regular);
	// Pentagram Measurements
	pent_sides = 5;
	// echo("pent_sides = ", pent_sides);
	pent_outer = 360 / pent_sides;
	// echo("pent_outer = ", pent_outer);
	pent_inner = (pent_sides - 2) * 180 / pent_sides;
	// echo("pent_inner = ", pent_inner);
	pent_radius = RegPoly_Radius_From_Side(pent_sides, pent_side);
	// echo("pent_radius = ", pent_radius);
	pent_apotham = RegPoly_Apothem_From_Radius(pent_sides, pent_radius);
	// echo("pent_apothem = ", pent_apotham);
	// Triangle Measurements
	tri_sides = 3;
	tri_base = pent_side;
	tri_base_outer = (regular == true ? 360 / tri_sides : pent_inner);
	tri_base_inner = (regular == true ? (tri_sides - 2) * 180 / tri_sides : pent_outer);
	tri_height =
	    (regular == true ? (pent_side * sqrt(3)) / 2 : IsoTri_Height_From_Base_and_Angle(tri_base, pent_outer));
	tri_side = (regular == true ? tri_base : IsoTri_Side_From_Base_and_Angle(tri_base, pent_outer));
	tri_apex_inner = (regular == true ? tri_base_inner : 180 - 2 * tri_base_inner);
	tri_apex_outer = (regular == true ? tri_base_outer : 180 - tri_apex_inner);
	// echo("tri_sides = ", tri_sides);
	// echo("tri_base = ", tri_side);
	// echo("tri_base_outer = ", tri_base_outer);
	// echo("tri_base_inner = ", tri_base_inner);
	tri_radius = RegPoly_Radius_From_Side(tri_sides, tri_base);
	// echo("tri_radius = ", tri_radius);
	tri_apotham = RegPoly_Apothem_From_Radius(tri_sides, tri_radius);
	// echo("tri_apothem = ", tri_apotham);
	// echo("tri_height = ", tri_height);
	// echo("tri_side = ", tri_side);
	// echo("tri_apex_outer = ", tri_apex_outer);
	// echo("tri_apex_inner = ", tri_apex_inner);
	x = 0 - (tri_base / 2);
	y = 0;
	point1 = [ x, y ];
	star_angles = [
		tri_base_inner, 360 - tri_base_inner, 360 - (tri_base_outer - pent_inner),
		360 - tri_apex_outer - (tri_base_outer - pent_inner), 360 - tri_base_outer + (pent_outer / 2),
		tri_apex_outer + (tri_base_outer - pent_inner) * 3, 360 - (tri_apex_outer + (tri_base_outer - pent_inner) * 3),
		(tri_base_outer - pent_inner) * 2 + tri_base_inner, tri_apex_outer + (tri_base_outer - pent_inner)
	];
	// echo("star_angles = ", star_angles);
	point2 = [ point1[0] + tri_side * cos(star_angles[0]), point1[1] + tri_side * sin(star_angles[0]) ];
	point3 = [ point2[0] + tri_side * cos(star_angles[1]), point2[1] + tri_side * sin(star_angles[1]) ];
	point4 = [ point3[0] + tri_side * cos(star_angles[2]), point3[1] + tri_side * sin(star_angles[2]) ];
	point5 = [ point4[0] + tri_side * cos(star_angles[3]), point4[1] + tri_side * sin(star_angles[3]) ];
	// point5 = [50, -43.30127];
	point6 = [ point5[0] + tri_side * cos(star_angles[4]), point5[1] + tri_side * sin(star_angles[4]) ];
	// point6 = [75, -86.60254];
	point7 = [ point6[0] + tri_side * cos(star_angles[5]), point6[1] + tri_side * sin(star_angles[5]) ];
	point8 = [ point7[0] + tri_side * cos(star_angles[6]), point7[1] + tri_side * sin(star_angles[6]) ];
	point9 = [ point8[0] + tri_side * cos(star_angles[7]), point8[1] + tri_side * sin(star_angles[7]) ];
	point10 = [ point9[0] + tri_side * cos(star_angles[8]), point9[1] + tri_side * sin(star_angles[8]) ];
	star_points = [ point1, point2, point3, point4, point5, point6, point7, point8, point9, point10 ];

	// echo("star_points: ", star_points);
	translate([ 0, pent_apotham, 0 ])
	polygon(star_points);
}

module Generate_Star()
{
	if (rounded == true)
	{
		// echo("Rounded specified with Radius = ", rounded_radius);
		difference()
		{
			offset(r = rounded_radius) Plot_Star(base_size, regular = regular_star);
		}
	}
	else
	{
		// echo("Not rounded...");
		Plot_Star(base_size, regular = regular_star);
	}
}
// if (rextrude == true)
// {
//     rotate([90, 0, 0])
//         rotate_extrude(angle=75, convexity=10, $fn=100)
//             translate([200, 0, 0])
//                 rotate([0, 0, -90])
//                    Generate_Star();
// } else {
//     if (lextrude == true)
//     {
//         linear_extrude(height=lextrude_height, center=lextrude_center, twist=lextrude_twist, slices=lextrude_slices,
//         convexity=0, scale=lextrude_scale, $fn=lextrude_facets) {
//             Generate_Star();
//         }
//     } else {
//         Generate_Star();
//     }
// }
