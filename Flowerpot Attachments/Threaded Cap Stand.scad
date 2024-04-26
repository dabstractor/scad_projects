$fn = 36 * 5;
include <Round-Anything/polyround.scad>
use <threads-scad/threads.scad>

threaded = false;

module ThreadedCapStand()
{
    union()
    {
        if (threaded)
            translate([ 0, 0, -5 ]) RodStart(5, 0, 6, 6, 1, $fn = 36);
        else
            rotate_extrude() polygon(polyRound([

                [ 0, 0, 0 ],
                [ 0, 19, 2 ],
                [ 5.2, 19, 2 ],
                [ 6.2, 17, 1 ],
                [ 6.2, 4, 1 ],
                [ 4, 1, 20 ],
                [ 3, 0, 20 ],

                // [ 3, 0, 0 ],
                [ 2, -9, 5 ],
                [ 0, -9, 1 ],
                [ 0, -7, 0 ],

            ]));

        // rotate_extrude(angle = 360) polygon(polyRound(
        //     [
        //         [ 0, 0, 0 ],
        //         [ 0, 19, 2 ],
        //         [ 5.2, 19, 2 ],
        //         [ 6.2, 17, 1 ],
        //         [ 6.2, 4, 1 ],
        //         [ 4, 1, 20 ],
        //         [ 3, 0, 1 ],
        //     ],
        //     120));
    }
}

ThreadedCapStand();
