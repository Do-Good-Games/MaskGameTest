shader_type spatial;

#include "res://Art/NeeaFolder/Shaders/shd_inc_height_to_normal.gdshaderinc"

render_mode world_vertex_coords;//, shadows_disabled;

uniform vec3 color : source_color = vec3(1.0);
// setting default values to uniform arrays is not supported
uniform float bubble_scale[3]; //0.1, 0.11, 0.15
uniform vec2 bubble_off[3]; //(0.12, 0.2), (-0.31, -0.064), (-0.526, 0.0)
uniform float bubble_speed = 1.4;
uniform float time_scrub;
uniform sampler2D tex_bubbles;
uniform sampler2D tex_cells;
uniform sampler2D tex_waves;

varying float vert_height;
varying float vert_bubbles;

float height_bubble(vec2 pos, float time)
{
	float k = 0.0;
	float anim_positive;
	float anim_negative;
	float anim_cells;
	vec2 uv;
	float delay = 1.2;
	float bubble_height = 0.4;
	float bubble_round = 1.5;
	float bubble_anim;
	float bubble;
	for (int i = 0; i < 3; ++i)
	{
		uv = pos * bubble_scale[i] + bubble_off[i];
		
		// fast pop
		//anim_cells = max(0.0, mod(time * texture(tex_cells, uv).r * bubble_speed, delay + 1.0) - delay);
		//bubble_anim = (1.0 - bubble) * bubble_height * anim_cells;
		
		// rain
		//bubble = pow(1.0 - texture(tex_bubbles, uv).r, bubble_round);
		//anim_cells = min(1.0, mod(time * (texture(tex_cells, uv).r + 0.1) * bubble_speed, delay + 1.0));
		bubble_anim = max(0.0, (1.0 - bubble) * bubble_height * anim_cells) + 2.0 * min(0.0, bubble * bubble_height - anim_cells);
		
		// slow pop
		bubble = pow(1.0 - texture(tex_bubbles, uv).r, bubble_round);
		//anim_cells = mod(time * (texture(tex_cells, uv).x + 0.1) * bubble_speed, delay * 2.0 + 1.0);
		anim_cells = mod(time * bubble_speed + (texture(tex_cells, uv).r + 0.1) * delay * 2.5, delay * 2.0 + 1.0);
		anim_positive = min(1.0, anim_cells);
		anim_negative = clamp(anim_cells - delay, 0.0, 1.0);
		bubble_anim = max(0.0, (1.0 - bubble) * bubble_height * anim_positive)
		+ 2.0 * min(0.0, bubble * bubble_height - anim_negative);
		
		k = max(k, bubble_anim);
	}
	return k;
}

float height_waves(vec2 pos, float time)
{
	vec2 uv = pos * 0.03;
	float wave_amp = 0.1;
	float wave_speed = 5.0;
	float wave_small = texture(tex_waves, uv * 4.0).r * 1.0;
	float wave_big = texture(tex_waves, uv + time / 300.0).r * 20.0;
	
	float wave_anim = wave_small * sin(time * wave_speed + wave_big) * wave_amp + wave_amp;
	
	return wave_anim;
}

float height(vec2 pos, out float waves, out float bubbles)
{
	float time = TIME;
	//time = time_scrub;
	waves = height_waves(pos, time);
	bubbles = height_bubble(pos, time);
	return max(waves, bubbles);
}

float sample(vec2 pos)
{
	float a, b;
	return height(pos, a, b);
}

void vertex()
{
	// Called for every vertex the material is visible on.
	vec2 pos = VERTEX.xz;
	float hw, hb;
	float k = height(pos, hw, hb);
	
	VERTEX += NORMAL * k;
	
	// Vertex Interpolated Normals
	// not able to create a function with a function parameter in gls
	vec2 off = vec2(0.05, 0.0);
	float norm_strength = 1.0;
	NORMAL = normalize(
		vec3((sample(pos - off) - sample(pos + off)) * norm_strength,
		2.0 * off.x,
		(sample(pos - off.yx) - sample(pos + off.yx)) * norm_strength));
	
	// varyings
	vert_height = k;
	vert_bubbles = hb;
}

void fragment()
{
	// Called for every pixel the material is visible on.
	vec3 col = color * mix(min(1.0, vert_height * 0.9 + 0.7), 1.4, vert_bubbles * 1.0);
	
	// more color options 
	//vec2 pos = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xz;
	//col *= min(1.0, texture(tex_waves, pos * 0.1 + vert_height).r + 0.5 + vert_bubbles);
	//col = col + texture(tex_waves, pos * 0.1 + vert_height).r * 0.1 + 0.1 + vert_bubbles * 0.4;
	// invert color: 1.0 - color
	
	ALBEDO = col;
	
	//ROUGHNESS = clamp(pow(1.0 - vert_height * 5.0, 4.0), 0.0, 1.0);
	ROUGHNESS = clamp((0.5 - vert_height) * 0.5, 0.0, 1.0); // good one
	
	// preview roughness
	//ROUGHNESS = 0.1;
	//ALBEDO = vec3(ROUGHNESS);
	
	// unused texture channels
	//EMISSION = vec3(0.5);
	//METALLIC = 1.0;
	
	// Fragment Normals
	//vec3 vert = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	//float k = height(vert.xz);
	//float norm_strength = 1.0;
	//NORMAL = height_to_normal(k, norm_strength, VERTEX, NORMAL);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
