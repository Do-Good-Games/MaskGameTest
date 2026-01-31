shader_type spatial;

uniform sampler2D noise;

// don't need
//#define TAU = 6.2831853071;

void vertex() {
	// Called for every vertex the material is visible on.
	VERTEX.y += cos(VERTEX.x * TAU * 2.0) * 0.2
	;
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
