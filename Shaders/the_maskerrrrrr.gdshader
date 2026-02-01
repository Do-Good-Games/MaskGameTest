shader_type canvas_item;
uniform sampler2D masks[5];
uniform sampler2D evil_masks[3];

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR = vec4(1,1,1,1);
	// IDK man a for loop just doesnt work?? You get copy-pasted code
	// Hours wasted: 2
	float evil_alpha = 0.0;
	evil_alpha += texture(evil_masks[0], UV).a;
	evil_alpha += texture(evil_masks[1], UV).a;
	evil_alpha += texture(evil_masks[2], UV).a;
	//evil_alpha += texture(evil_masks[3], UV).a;
	//evil_alpha += texture(evil_masks[4], UV).a;
	
	float alpha = 0.0;
	alpha += texture(masks[0], UV).a;
	alpha += texture(masks[1], UV).a;
	alpha += texture(masks[2], UV).a;
	alpha += texture(masks[3], UV).a;
	alpha += texture(masks[4], UV).a;
	alpha = clamp(alpha, 0, 1);

	COLOR.a *= alpha;
	COLOR.a *= 1.0-evil_alpha;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
