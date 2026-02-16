float flowmapBlend(out vec2 pos1, out vec2 pos2, vec2 pos, sampler2D tex_flowmap, sampler2D tex_noise, float coord_scale,
float blend_duration, float noise_scale, float noise_strength, float flow_scale, float cycle_speed, float flow_speed)
{
	// Intended use
	//mix(texture(tex_texture, pos1), texture(tex_texture, pos2), flow_blend)
	
	/////////// Config
	//float blend_cycle = 1.0;
	//float noise_scale = 0.1;
	//float noise_strength = 0.5;
	//float flow_scale = 1.5;
	//float cycle_speed = 0.3;
	//float flow_speed =  8.0;
	//float flow_blend;
	//vec2 pos1, pos2;
	
	/////////// FLowmap
	// Direction the flowmap colors represent
	vec2 channel_flow_direction = vec2(-1.0, 1.0);
	
	// How many seconds the UVs are moved before phasing 
	float half_cycle = blend_duration * 0.5;
	
	// Use noise texture for offset to reduce pulsing effect
	float offset = texture(tex_noise, pos * noise_scale).r * noise_strength;

	float phase1 = mod(offset + TIME * cycle_speed, blend_duration);
	float phase2 = mod(offset + TIME * cycle_speed + half_cycle, blend_duration);

	vec2 flow_tex = texture(tex_flowmap, pos * flow_scale).rg;
	vec2 flow;
	flow.x = flow_tex.r * 2.0 - 1.0;
	flow.y = flow_tex.g * 2.0 - 1.0;
	flow *= normalize(channel_flow_direction);

	// Make flow incluence on the normalmap strength adjustable (optional)
	//float normal_influence = mix(1.0, dot(abs(flow), vec2(1.0, 1.0)) * 0.5, flow_normal_influence);

	// Blend factor to mix the two layers
	float blend_factor = abs(half_cycle - phase1) / half_cycle;

	// Offset by halfCycle to improve the animation for color (for normalmap not absolutely necessary)
	phase1 -= half_cycle;
	phase2 -= half_cycle;

	// Multiply with scale to make flow speed independent from the uv scaling
	flow *= flow_speed * coord_scale;
	
	/////////// Output
	
	// Texture positions for each phase
	pos1 = flow * phase1 + pos;
	pos2 = flow * phase2 + pos;
	
	return blend_factor;
}