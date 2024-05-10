$fn = 360;

modes = [
    [ "coupling", ["down"] ],
    [ "elbow", ["front"] ],
    [ "tee", [ "left", "down" ] ],
    [ "corner", [ "left", "front" ] ],
    [ "4way", [ "left", "front", "down" ] ],
    [ "cross", [ "left", "right", "down" ] ],
    [ "pointer", [ "left", "right", "down", "front" ] ],
    [ "universal", [ "left", "front", "right", "down", "back" ] ],
];

inch = function(n) n * 25.4;

function get_directions(key) = [for (m = modes) if (m[0] == key) m[1]][0];

module cyl(h, r, trans = 0)
{
    translate([ 0, 0, trans ]) cylinder(h, r = r);
}

module legs(h, d, mode = "coupling", trans = 0)
{
    // up
    cyl(h, r = d / 2, trans);

    directions = get_directions(mode);
    echo("directions: ", directions);
    echo("Directions for mode '", mode, "':");
    for (direction = get_directions(mode))
    {
        if (direction == "down")
            rotate([ 180, 0, 0 ]) cyl(h, r = d / 2, trans);
        else if (direction == "front")
            rotate([ -90, 0, -90 ]) cyl(h, r = d / 2, trans);
        else if (direction == "left")
            rotate([ 90, 0, 0 ]) cyl(h, r = d / 2, trans);
        else if (direction == "right")
            rotate([ -90, 0, 0 ]) cyl(h, r = d / 2, trans);
        else if (direction == "back")
            rotate([ 90, 0, -90 ]) cyl(h, r = d / 2, trans);
    }
}

module joint(id, od, thickness, len, mode)
{
    ood = od + thickness;
    // lenth = len(get_directions(mode));
    // echo("lenth: ", lenth);
    len = len + id;

    difference()
    {
        union()
        {
            if (mode != "test")
                sphere(ood / 2);
            hull() legs(len, ood, mode);
        }
        color("red") union()
        {
            if (mode != "test")
                sphere(id / 2);
            legs(len, id, mode);
        }
        color("white") legs(len - id + 0.1, od, mode, id); // is_undef(length) ? 0 : ood);
    }
}

module test()
{
    translate([ 0, -190, 0 ]) joint(10, 12, 2, 15, "coupling");
    translate([ 0, -150, 0 ]) joint(10, 12, 2, 15, "elbow");
    translate([ 0, -100, 0 ]) joint(10, 12, 2, 15, "tee");
    translate([ 0, -50, 0 ]) joint(10, 12, 2, 15, "corner");
    translate([ 0, 0, 0 ]) joint(10, 12, 2, 15, "4way");
    translate([ 0, 50, 0 ]) joint(10, 12, 2, 15, "cross");
    translate([ 0, 120, 0 ]) joint(10, 12, 2, 15, "pointer");
    translate([ 0, 190, 0 ]) joint(10, 12, 2, 15, "universal");
}

test();
// joint(inch(0.8), inch(1.1), inch(0.15), inch(1.1), "corner");
