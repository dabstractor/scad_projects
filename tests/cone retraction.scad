$fn = 36 * 10;
NOZZLE_DIAMETER = 0.8;
LAYER_HEIGHT = 0.36;

BASE_OD = 20;
ANGLE = 45;

BASE_OR = BASE_OD / 2;

height = tan(ANGLE) * BASE_OR;

echo("height:", height);

WALL_LINE_COUNT = 1;
USING_THIN_WALLS = false;

module cone()
{
    cylinder(h = height + (USING_THIN_WALLS ? 0 : 0.2), r1 = BASE_OR, r2 = NOZZLE_DIAMETER);
}

render() difference()
{
    cone();

    // wall_thickness = tan(ANGLE) * NOZZLE_DIAMETER * WALL_LINE_COUNT + (USING_THIN_WALLS ? 0 : 1);
    // echo("wall_thickness:", wall_thickness);
    // translate([ 0, 0, layer_movement ]) cone();

    //  - cos(ANGLE) * layer_movement
    cylinder(h = height, r1 = BASE_OR - NOZZLE_DIAMETER * WALL_LINE_COUNT - (USING_THIN_WALLS ? 0 : 0.2), r2 = 0);
}
// cone();