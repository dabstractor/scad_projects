$fn = 120;

module adapter()
{
    union()
    {

        difference()
        {

            difference()
            {

                cylinder(h = 40, d = 40, center = true, $fn = 360);
                translate([ 0, 0, 8 ]) rotate_extrude(angle = 360) translate([ 21, 0, 0 ]) circle(d = 4);
            }
            cylinder(h = 70, d = 30, center = true, $fn = 360);
        }

        translate([ 0, 0, 20 ]) difference()
        {

            cylinder(35, r1 = 17, r2 = 15.6, $fn = 360);
            cylinder(h = 50, d = 27, $fn = 360);
        }
    }
}

adapter();
