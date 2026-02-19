shader_type spatial;

// this doesn't work, maybe use stencils

render_mode depth_draw_always, unshaded;

//void vertex() {
	//// Called for every vertex the material is visible on.
//}

void fragment() {
	// Called for every pixel the material is visible on.
	ALBEDO = vec3(0.0);
	//ALPHA = 0.0;
	//DEPTH = 1.0;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
