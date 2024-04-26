$fn = 36 * 2;
include <Round-Anything/polyround.scad>
include <./StarMaker5.scad>

GRINDER_HEIGHT = 27.5;
GRINDER_OD = 76;
GRINDER_CORNER_RADIUS = 5;

WALL_THICKNESS = 1.6;

GRINDER_OR = GRINDER_OD / 2;

SIDE_GAP = 4;

SILICONE_DEPTH_LAYERS = 6;

LAYER_HEIGHT = 0.32;

star_depth = SILICONE_DEPTH_LAYERS * LAYER_HEIGHT;
side_height = GRINDER_HEIGHT / 2 + WALL_THICKNESS + star_depth;
side_or = GRINDER_OR + WALL_THICKNESS;

bump_height = side_height / 2 - SIDE_GAP / 4.05 + star_depth - 1;
bump_count = 5;

module star()
{
	scaling_factor = 2.5;
	color("red")
	translate([ 0, 0, -GRINDER_HEIGHT / 2 - star_depth * scaling_factor + 0.1 ])
	linear_extrude(height = star_depth * scaling_factor, scale = 0.5) Plot_Star(GRINDER_OR / 2 - 3);
}

module grinder()
{
	translate([ 0, 0, -GRINDER_HEIGHT / 2 ])
	rotate_extrude(angle = 360) polygon(polyRound(
	    [
		    [ 0, 0, 0 ],
		    [ 0, GRINDER_HEIGHT, 0 ],
		    [ GRINDER_OR, GRINDER_HEIGHT, GRINDER_CORNER_RADIUS ],
		    [ GRINDER_OR, 0, GRINDER_CORNER_RADIUS ],
	    ],
	    $fn / 10));

	star();

	// translate([ 0, 0, GRINDER_HEIGHT / 2 + star_depth ])
	mirror([ 0, 0, 1 ]) star();
}

module spread(total, i)
{
	rotate([ 0, 0, 360 / total * i ])
	children();
}

module bump()
{
	translate([ side_or - 2, 0, -bump_height - SIDE_GAP / 2 ])
	sphere(r = bump_height);
}

module bumps()
{

	for (i = [0:bump_count])
	{

		spread(bump_count, i) bump();
	};
}

module side()
{

	difference()
	{

		difference()
		{
			union()
			{

				color("white") translate([ 0, 0, -side_height - star_depth ])
				rotate_extrude(angle = 360) polygon(polyRound(
				    [
					    [ 0, 0, 0 ],
					    [ 0, side_height, 0 ],
					    [ side_or, side_height, 0 ],
					    [ side_or, -star_depth, WALL_THICKNESS * 4 ],
				    ],
				    $fn / 10));
				bumps();
			}


			scale([ 1, 1, 1.04 ]) grinder();
		}
	}
}

side();

// grinder();
// mirror([ 0, 0, 1 ]) side();
// linear_extrude(height = 5, r1 = 1, center = true) star(5, 1, GRINDER_OR / 2, GRINDER_OD / 2 - 1);
// Generate_Star();
// rotate_extrude(angle = 25) Plot_Star(GRINDER_OR);

// grinder();
// difference()
// {

// star();

// grinder();

// mirror([ 0, 0, 1 ]) side();
