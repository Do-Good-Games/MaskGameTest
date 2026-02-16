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
uniform float depth_near = 0.05;
uniform float depth_far = 100;
uniform float depth_falloff_distance: hint_range(0.0, 1.0, 0.1) = 0.4;
uniform float depth_edge_bias: hint_range(0.0, 1.0, 0.1) = 0.1;

uniform sampler2D tex_waves;
uniform sampler2D depth_texture : hint_depth_texture;

varying float vert_height;

float wave(vec2 pos)
{
	//pos += texture(tex_waves, pos / noise_size).r * 2.0 - 1.0;
	//vec2 st = 1.0 - abs(sin(pos));
	//return pow(1.0 - pow(st.x * st.y, 0.65), 4.0);
	pos += texture(tex_waves, pos / noise_size * 0.2).r * TAU;
	vec2 st = 1.0 - abs(sin(pos * 1.2));
	return pow(1.0 - pow(st.x * st.y, 0.65), 4.0);
}

float height(vec2 pos)
{
	//vec2 off = 0.01 * cos(pos + TIME);
	//return texture(tex_waves, (pos / noise_size) + off).x;
	float adj = 0.8;
	float k = 0.0;
	//float wf = wave_freq;
	float wf = wave_freq * 1.3;
	float wh = wave_height;
	for(int i = 0; i < 4; ++i)
	{
		k += wave(pos + TIME * float((i & 1) * 2 - 1) * wf) * wh;
		wf /= adj;
		wh *= adj;
	}
	return k;
}

float edge(float near, float far, float depth)
{
	depth = 1.0 - 2.0 * depth;
	return near * far / (far + depth * (near - far));
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
	
	/////////// Edge Depth Foam
	//// doesn't work with an orthogonal camera :(
	//// must raise the water tiles up 1 so the edge can fade completely
	//// set edge near/far to your camera near/far - TODO convert to uniform
	//float z_depth = edge(depth_near, depth_far, texture(depth_texture, SCREEN_UV).x); // depth texture
	//float z_pos = edge(depth_near, depth_far, FRAGCOORD.z); // from position
	//float water_depth = z_depth - z_pos; // diff
	//water_depth = max(water_depth, 0.0); // make sure waterdepth >= 0
	//// Calculate linear falloff value
    //float falloff = 1.0 - (water_depth / depth_falloff_distance) + depth_edge_bias;
	//
	//vec2 pos = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xz * 0.5;
	//float foam_tex1 = min(1.0, pow(texture(tex_waves, pos * 0.4 + vert_height * 0.4 + TIME * 0.1).r * 1.5, 2.0));
	//float foam_tex2 =  min(1.0, pow(texture(tex_waves, pos * 0.8 + vert_height * 0.8 - vec2(1.0, 0.5) * TIME * 0.15).r * 1.2, 2.0));
	////float foam_edge = clamp(foam_tex1 * foam_tex2 * falloff, 0.0, 1.0);
	//float foam_edge = clamp(falloff, 0.0, 1.0);
	
	//vec3 albedo_col = vec3(cos(UV.x * TAU * 5.0));
	//vec3 albedo_col = color * pow(vert_height, 0.1) + pow(vert_height, foam) * foam;
	//vec3 albedo_col = mix(color_dark, color, pow(vert_height, 0.2)) + pow(vert_height, foam) * foam + foam_edge * 0.5;
	vec3 albedo_col = mix(color_dark, color, pow(vert_height, 0.2)) + pow(vert_height, foam) * foam;
	//albedo_col = vec3(foam_edge);
	
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
