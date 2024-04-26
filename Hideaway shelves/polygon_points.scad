module polygon_points(n, r)
{
	points = [];
	for (i = [0:n - 1])
	{
		angle = 360 / n * i;
		x = r * cos(angle);
		y = r * sin(angle);
		points[i] = [ x, y ];
	}
	return points;
}
