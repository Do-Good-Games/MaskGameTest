shader_type spatial;

#include "res://Art/NeeaFolder/Shaders/shd_inc_flowmap.gdshaderinc"

render_mode world_vertex_coords, shadows_disabled;

uniform vec2 lava_offset;
uniform float lava_scale = 0.2;

uniform vec3 color_hot : source_color; //f55516
uniform vec3 color_cold : source_color; //940909
uniform float emit_strength = 3.0;
uniform float wave_speed = 0.7;
uniform float wave_height = 1.8;
uniform float flow_scale = 1.5;
uniform float flow_cycle_speed = 0.3;
uniform float flow_speed =  5.0;

//uniform sampler2D tex_lava_albedo : hint_default_white;
uniform sampler2D tex_lava_roughness : hint_roughness_r;
uniform sampler2D tex_lava_normal : hint_normal;
uniform sampler2D tex_lava_emit;
//uniform sampler2D tex_lava_height;
uniform sampler2D tex_lava_flow : hint_anisotropy;
uniform sampler2D tex_waves;

varying float vert_height;

float height_waves(vec2 pos, float time)
{
	vec2 uv = pos * 0.03;
	float wave_amp = wave_height;
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
	
	// too subtle because of the emission
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
	vec2 pos = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xz * lava_scale + lava_offset;
	
	// flow map
	float blend_duration = 1.0;
	float noise_scale = 0.3;
	float noise_strength = 1.0;
	float flow_blend;
	vec2 pos1, pos2;
	flow_blend = flowmapBlend(pos1, pos2, pos, tex_lava_flow, tex_waves, lava_scale,
	blend_duration, noise_scale, noise_strength, flow_scale, flow_cycle_speed, flow_speed);

	// cooling color
	//float off = min(1.0, pow(texture(tex_waves, pos * 0.2).r, 1.5)) * TAU;
	//float off = (1.0 - vert_height) * TAU;
	//float cooling = sin(TIME + off) * 0.5 + 0.5;
	float cooling_blend = clamp((1.0 - pow(vert_height, 1.5)) * 2.0, 0.0, 1.0);
	//cooling_blend = 0.5;
	vec3 cooling_col = mix(color_cold, color_hot, cooling_blend);
	
	//float albedo_mask = mix(texture(tex_lava_albedo, pos1), texture(tex_lava_albedo, pos2), flow_blend).r;
	float emit_mask = mix(texture(tex_lava_emit, pos1), texture(tex_lava_emit, pos2), flow_blend).r;
	
	//vec3 albedo_col = cooling_col * albedo_mask;
	vec3 emit_col = cooling_col * pow(emit_mask, 2.5) * emit_strength * min(1.0, cooling_blend + (0.7 - emit_strength * 0.1));
	float rough_col = mix(texture(tex_lava_roughness, pos1), texture(tex_lava_roughness, pos2), flow_blend).r;
	vec3 normal_col = mix(texture(tex_lava_normal, pos1), texture(tex_lava_normal, pos2), flow_blend).rgb;
	
	//emit_col = col;
	//emit_col = texture(tex_waves, pos * noise_scale).rgb;
	
	ALBEDO = emit_col;
	EMISSION = emit_col;
	ROUGHNESS = rough_col;
	NORMAL_MAP = normal_col;
	
	// unused texture channels
	//METALLIC = 0.0;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
