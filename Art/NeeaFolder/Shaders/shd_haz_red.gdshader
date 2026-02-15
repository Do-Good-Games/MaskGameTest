shader_type spatial;

render_mode world_vertex_coords;//, shadows_disabled;

uniform vec2 offset;
uniform float scale = 0.2;

uniform vec3 color_hot : source_color; //f55516
uniform vec3 color_cold : source_color; //940909
uniform float emit_strength = 2.0;
uniform float wave_speed = 0.5;

uniform sampler2D tex_waves;
uniform sampler2D tex_lava_albedo : hint_default_white;
uniform sampler2D tex_lava_roughness : hint_roughness_r;
uniform sampler2D tex_lava_normal : hint_normal;
uniform sampler2D tex_lava_emit;
uniform sampler2D tex_lava_height;
uniform sampler2D tex_lava_flow : hint_anisotropy;

varying float vert_height;

float height_waves(vec2 pos, float time)
{
	vec2 uv = pos * 0.03;
	float wave_amp = 1.5;
	wave_amp /= 2.0;
	float wave_base = texture(tex_waves, uv + time / 300.0).r * 2.0 - 1.0;
	//float wave_wobble = texture(tex_waves, uv * 0.5 + vec2(2.5, 0.6)).r * TAU;
	float wave_wobble = texture(tex_waves, uv * 0.5).r * TAU;
	
	float wave_anim = wave_base * sin(time * wave_speed + wave_wobble) * wave_amp + wave_amp;
	
	return wave_anim;
}

float height(vec2 pos)
{
	float time = TIME;
	//time = time_scrub;
	return height_waves(pos, time);
}

void vertex() {
	// Called for every vertex the material is visible on.
	vec2 pos = VERTEX.xz;
	float k = height(pos);
	
	VERTEX += NORMAL * k;
	
	// not needed for this material
	// Vertex Interpolated Normals
	// not able to create a function with a function parameter in gls
	//vec2 off = vec2(0.05, 0.0);
	//float norm_strength = 1.0;
	//NORMAL = normalize(
		//vec3((height(pos - off) - height(pos + off)) * norm_strength,
		//2.0 * off.x,
		//(height(pos - off.yx) - height(pos + off.yx)) * norm_strength));
	
	vert_height = k;
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 pos = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xz * scale + offset;
	
	//float off = min(1.0, pow(texture(tex_waves, pos * 0.2).r, 1.5)) * TAU;
	float off = (1.0 - vert_height) * TAU;
	//float cooling = sin(TIME + off) * 0.5 + 0.5;
	float cooling = clamp((1.0 - vert_height) * 2.0, 0.0, 1.0);
	vec3 col = mix(color_cold, color_hot, cooling);
	
	vec3 col_emit = col * pow(texture(tex_lava_emit, pos).r, 2.5) * emit_strength * min(1.0, cooling + 0.4);
	vec3 col_albedo = col * texture(tex_lava_albedo, pos).r;
	
	//col_emit = vec3(col_off);
	//col_emit = col;
	
	ALBEDO = col_emit;
	ROUGHNESS = texture(tex_lava_roughness, pos).r;
	NORMAL_MAP = texture(tex_lava_normal, pos).rgb;
	
	EMISSION = col_emit;
	
	// unused texture channels
	//METALLIC = 0.0;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
