SQUARE_COUNT = 1;
SQUARE_SIZE = 20;

NOZZLE_DIAMETER = 0.4;
LAYER_HEIGHT = 2.4 / 4 * NOZZLE_DIAMETER;
echo("LAYER_HEIGHT:", LAYER_HEIGHT);

module squares()
{
    grid_rows = floor(sqrt(SQUARE_COUNT));
    grid_cols = ceil(SQUARE_COUNT / grid_rows);
    echo("grid_rows:", grid_rows);
    echo("SQUARE_COUNT:", SQUARE_COUNT);
    modulo = SQUARE_COUNT % grid_rows;
    echo("modulo:", modulo);

    for (i = [0:grid_cols - 1])
    {
        itLimit = i != grid_rows - 1 || modulo == 0 ? grid_rows : modulo;
        echo("itLimit:", itLimit);

        for (j = [0:itLimit - 1])
        {
            translate([ j * SQUARE_SIZE * 2, i * SQUARE_SIZE * 2, 0 ]) cube([ SQUARE_SIZE, SQUARE_SIZE, LAYER_HEIGHT ]);
        }
        // grid should be the square root of the square size and iterate in both directions
        // place squares in a grid by translating x and y

        // translate([ i * SQUARE_SIZE * 2, i * SQUARE_SIZE * 2, 0 ]) square();
        // translate([ i * SQUARE_SIZE * 2, 0, 0 ]) square();
    }
}

squares();