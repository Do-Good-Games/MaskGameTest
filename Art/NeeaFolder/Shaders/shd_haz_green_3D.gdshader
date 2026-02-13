shader_type spatial;

render_mode world_vertex_coords;//, shadows_disabled;

uniform vec4 color : source_color = vec4(1.0);
uniform sampler2D bubbles;
uniform sampler3D bubbles3;

varying float _height;

void vertex() {
	// Called for every vertex the material is visible on.
	_height = (1.0 - pow(1.0 - texture(bubbles3, vec3(VERTEX.xz / 2.0, TIME * 0.3)).x, 2.38)) * 0.3;
	VERTEX.y += _height;
	//VERTEX.y = texture(bubbles3, VERTEX).y;
	//NORMAL = normalize(vec3(_height, 1.0, _height));
}

void fragment() {
	// Called for every pixel the material is visible on.
	//ALBEDO = texture(bubbles, UV).xyz;
	float k = texture(bubbles, UV).x * 0.2;
	ALBEDO = color.xyz + _height;
	//NORMAL = normalize(vec3(k, 0.0, 0.0));
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
