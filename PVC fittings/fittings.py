from solid import *
from solid.utils import *

modes = {
    "coupling": ["down"],
    "elbow": ["front"],
    "tee": ["left", "down"],
    "corner": ["left", "front"],
    "4way": ["left", "front", "down"],
    "cross": ["left", "right", "down"],
    "pointer": ["left", "right", "down", "front"],
    "universal": ["left", "front", "right", "down", "back"],
}


def inch(n):
    return n * 25.4


def cyl(h, r, trans=0):
    return translate([0, 0, trans])(cylinder(h=h, r=r))


def legs(h, d, mode="coupling", trans=0):
    # up
    value = cyl(h, d / 2, trans)

    for direction in modes[mode]:
        if direction == "down":
            value += rotate([180, 0, 0])(cyl(h, d / 2, trans))
        elif direction == "front":
            value += rotate([-90, 0, -90])(cyl(h, d / 2, trans))
        elif direction == "left":
            value += rotate([90, 0, 0])(cyl(h, d / 2, trans))
        elif direction == "right":
            value += rotate([-90, 0, 0])(cyl(h, d / 2, trans))
        elif direction == "back":
            value += rotate([90, 0, -90])(cyl(h, d / 2, trans))

    return value


def joint(id, od, thickness, len, mode):
    ood = od + thickness
    # lenth = len(get_directions(mode));
    # echo("lenth: ", lenth);
    len = len + id

    return (
        (sphere(ood / 2) + hull()(legs(len, ood, mode)))
        - (color("red")(legs(len, id, mode)) + sphere(id / 2))
        - color("white")(legs(len - id + 0.1, od, mode, id))
    )


def test():
    return (
        translate([0, -190, 0])(joint(10, 12, 2, 15, "coupling"))
        + translate([0, -190, 0])(joint(10, 12, 2, 15, "coupling"))
        + translate([0, -150, 0])(joint(10, 12, 2, 15, "elbow"))
        + translate([0, -100, 0])(joint(10, 12, 2, 15, "tee"))
        + translate([0, -50, 0])(joint(10, 12, 2, 15, "corner"))
        + translate([0, 0, 0])(joint(10, 12, 2, 15, "4way"))
        + translate([0, 50, 0])(joint(10, 12, 2, 15, "cross"))
        + translate([0, 120, 0])(joint(10, 12, 2, 15, "pointer"))
        + translate([0, 190, 0])(joint(10, 12, 2, 15, "universal"))
    )


f = joint(inch(0.8), inch(1.1), inch(0.15), inch(1.1), "corner")

scad_render_to_file(test(), "fittings.scad", file_header="$fn=360;")
