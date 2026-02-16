shader_type spatial;

render_mode world_vertex_coords, shadows_disabled; //specular_toon;

uniform vec3 color : source_color; //12648e
uniform vec3 color_dark : source_color; //040e4a
uniform float rough : hint_range(0, 1) = 0.22;
//uniform float rim : hint_range(0, 1) = 0.2;
uniform float noise_size = 10.0;
uniform float wave_freq = 0.5;
uniform float wave_height = 0.21;
uniform float foam = 8.0;

uniform sampler2D tex_waves;

varying float vert_height;

float wave(vec2 pos)
{
	pos += texture(tex_waves, pos / noise_size).x * 2.0 - 1.0;
	vec2 st = 1.0 - abs(sin(pos));
	return pow(1.0 - pow(st.x * st.y, 0.65), 4.0);
}

float height(vec2 pos)
{
	//vec2 off = 0.01 * cos(pos + TIME);
	//return texture(tex_waves, (pos / noise_size) + off).x;
	float adj = 0.8;
	float k = 0.0;
	float wf = wave_freq;
	float wh = wave_height;
	for(int i = 0; i < 4; ++i)
	{
		k += wave(pos + TIME * float((i & 1) * 2 - 1) * wf) * wh;
		wf /= adj;
		wh *= adj;
	}
	return k;
}

void vertex()
{
	// Called for every vertex the material is visible on.
	//VERTEX.y += cos(TIME * 5.0 + VERTEX.x * TAU * 2.0) * 0.2;
	
	//float height = texture(tex_waves, VERTEX.xz / 2.0 + 0.5).x * 0.2;
	//VERTEX.y += height;
	
	vec2 pos = VERTEX.xz;
	//pos = (MODEL_MATRIX * vec4(VERTEX, 0.0)).xz; // another way to get world coordinates
	float k = height(pos);
	VERTEX.y += k;
	
	// Vertex Interpolated Normals
	// not able to create a function with a function parameter in gls
	vec2 off = vec2(0.05, 0.0);
	float normStrength = 1.0;
	NORMAL = normalize(
		vec3((height(pos - off) - height(pos + off)) * normStrength,
		2.0 * off.x,
		(height(pos - off.yx) - height(pos + off.yx)) * normStrength));
	
	vert_height = k; // interpolate between verticies to get values per pixel
}

void fragment()
{
	// Called for every pixel the material is visible on.
	//vec3 albedo_col = vec3(cos(UV.x * TAU * 5.0));
	//vec3 albedo_col = color * pow(vert_height, 0.1) + pow(vert_height, foam) * foam;
	vec3 albedo_col = mix(color_dark, color, pow(vert_height, 0.2)) + pow(vert_height, foam) * foam;
	
	ALBEDO = albedo_col;
	ROUGHNESS = rough;
	
	// unused texture channels
	//RIM = rim; // not seeing any affect
	//METALLIC = 0.0;
	//EMISSION = ALBEDO;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
