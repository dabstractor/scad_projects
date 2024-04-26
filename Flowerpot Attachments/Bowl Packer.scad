$fn = 36 * 10;
include <Round-Anything/polyround.scad>

bowl_od = 22.5;
bowl_id = 18;
bowl_top_height = 9;
funnel_height = 20;
funnel_top_id = 65;
vase_mode = true;
line_width = 0.8;
thickness = (vase_mode) ? line_width : bowl_od - bowl_id;

slope = funnel_height / (funnel_top_id - bowl_id);
bowl_or = bowl_od / 2;
bowl_ir = bowl_id / 2;
funnel_top_ir = funnel_top_id / 2;
funnel_top_or = funnel_top_ir + thickness / 2;

cuff_outer = bowl_or + thickness / 2;

grinder_height = 7;
grinder_od = 76;
grinder_or = grinder_od / 2;

// thickness = vase_mode ? line_width : thickness;
// angle generated from slope
angle = atan(slope);

echo("thickness:", thickness);

inner_profile = 
[
	    // [ bowl_ir, 0, 0 ],
	    // [ bowl_or, 0, 1 ],
	    // [ bowl_or, -bowl_top_height, 0 ],
	    // [ (cuff_outer + bowl_or) / 2, -bowl_top_height, 2 ],
	    // // [ cuff_outer, -bowl_top_height - 2, 2 ],
	    // [ cuff_outer, slope *thickness, 100 ],

	    [ bowl_or + thickness * 1.4, -bowl_top_height -2 , 0 ],
	    [ bowl_or + thickness * 1.3, -2, 1 ],
	    [ bowl_ir + thickness, 0, 1 ],
	    [ grinder_or + thickness+ 1, funnel_height + grinder_height - thickness / 2, 0 ],

];

// outer_profile = [
// 	    [ funnel_top_ir + thickness / 2, funnel_height, 40 ],
// 	    // [ funnel_top_ir + thickness / 2, funnel_height + grinder_height - thickness / 2, 40 ],
// 	    [ grinder_or + sin(angle) * thickness / 2, funnel_height + grinder_height - thickness / 2, 2 ],
// 	    [ grinder_or + sin(angle) * thickness / 2, funnel_height + grinder_height, 0 ],
// 	    // [ grinder_or, funnel_height + grinder_height, 0 ],
// 	    [ grinder_or, funnel_height + grinder_height, 0 ],
// 	    // [ grinder_or, funnel_height + grinder_height * 2, 0 ],
// 	    // [ grinder_or + thickness / 2, funnel_height + grinder_height, 0 ],
// 	    // [ funnel_top_ir, funnel_height + grinder_height, 40 ],
// 	    [ funnel_top_ir, funnel_height, 40 ],
// ];

inner_len = len(inner_profile);
profile = concat(inner_profile, [for (i = [1:inner_len]) inner_profile[inner_len -i] - [thickness + (vase_mode ? i<inner_len ? 2 : 0 : 0), 0, 0]]);
echo("profile:", profile  );

rotate_extrude(angle = 360) polygon(polyRound(
	   profile,
$fn / 5));

    // [
	  //   [ bowl_ir, 0, 0 ],
	  //   [ bowl_or, 0, 1 ],
	  //   [ bowl_or, -bowl_top_height, 0 ],
	  //   [ (cuff_outer + bowl_or) / 2, -bowl_top_height, 2 ],
	  //   // [ cuff_outer, -bowl_top_height - 2, 2 ],
	  //   [ cuff_outer, slope *thickness, 100 ],
	  //   [ funnel_top_ir + thickness / 2, funnel_height, 40 ],
	  //   // [ funnel_top_ir + thickness / 2, funnel_height + grinder_height - thickness / 2, 40 ],
	  //   [ grinder_or + sin(angle) * thickness / 2, funnel_height + grinder_height - thickness / 2, 2 ],
	  //   [ grinder_or + sin(angle) * thickness / 2, funnel_height + grinder_height, 0 ],
	  //   // [ grinder_or, funnel_height + grinder_height, 0 ],
	  //   [ grinder_or, funnel_height + grinder_height, 0 ],
	  //   // [ grinder_or, funnel_height + grinder_height * 2, 0 ],
	  //   // [ grinder_or + thickness / 2, funnel_height + grinder_height, 0 ],
	  //   // [ funnel_top_ir, funnel_height + grinder_height, 40 ],
	  //   [ funnel_top_ir, funnel_height, 40 ],
    // ],
