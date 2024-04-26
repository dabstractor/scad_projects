module side() {
  cube([1.6, 5, 15],center = true);
}

module button() {
  // rotate([0,  0, 90])
  // side();
  side();
  
  translate([1.7,0,7.5])
  sphere(d=5, center=true, $fn=360);
}

button();