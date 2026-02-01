shader_type canvas_item;
uniform sampler2D mask;
uniform sampler2D[20] bonusMasks;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR *= texture(mask, UV);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
