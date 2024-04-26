module rotate_around_axis(x, y, z, pt)
{
	translate(pt)
	rotate([ x, y, z ])
	translate(-pt)
	children();
}
