shader_type spatial;

#include "res://Art/NeeaFolder/Shaders/shd_inc_height_to_normal.gdshaderinc"

render_mode world_vertex_coords;//, shadows_disabled;

uniform vec4 color : source_color = vec4(1.0);
// setting default values to uniform arrays is not supported
uniform float bubbleScale[3];
uniform vec2 bubbleOff[3];
uniform float bubbleSpeed = 1.4;
uniform float timeScrub;
uniform sampler2D texBubbles;
uniform sampler2D texCells;
uniform sampler2D texWaves;

varying float vertHeight;

float heightBubble(vec2 pos, float time)
{
	float k = 0.0;
	float animPositive;
	float animNegative;
	float animCells;
	vec2 uv;
	float delay = 1.2;
	float bubbleHeight = 0.4;
	float bubbleRound = 1.5;
	float bubbleAnim;
	float bubble;
	for (int i = 0; i <= 3; ++i)
	{
		uv = pos * bubbleScale[i] + bubbleOff[i];
		
		// fast pop
		//animCells = max(0.0, mod(time * texture(texCells, uv).x * bubbleSpeed, delay + 1.0) - delay);
		//bubbleAnim = (1.0 - bubble) * bubbleHeight * animCells;
		
		// rain
		//bubble = pow(1.0 - texture(texBubbles, uv).x, bubbleRound);
		//animCells = min(1.0, mod(time * (texture(texCells, uv).x + 0.1) * bubbleSpeed, delay + 1.0));
		bubbleAnim = max(0.0, (1.0 - bubble) * bubbleHeight * animCells) + 2.0 * min(0.0, bubble * bubbleHeight - animCells);
		
		// slow pop
		bubble = pow(1.0 - texture(texBubbles, uv).x, bubbleRound);
		//animCells = mod(time * (texture(texCells, uv).x + 0.1) * bubbleSpeed, delay * 2.0 + 1.0);
		animCells = mod(time * bubbleSpeed + (texture(texCells, uv).x + 0.1) * delay * 2.5, delay * 2.0 + 1.0);
		animPositive = min(1.0, animCells);
		animNegative = clamp(animCells - delay, 0.0, 1.0);
		bubbleAnim = max(0.0, (1.0 - bubble) * bubbleHeight * animPositive)
		+ 2.0 * min(0.0, bubble * bubbleHeight - animNegative);
		
		k = max(k, bubbleAnim);
	}
	return k;
}

float heightWaves(vec2 pos, float time)
{
	vec2 uv = pos * 0.03;
	float waveAmp = 0.1;
	float waveSpeed = 5.0;
	float waveSmall = texture(texWaves, uv * 4.0).x * 1.0;
	float waveBig = texture(texWaves, uv + time / 300.0).x * 20.0;
	
	float waveAnim = waveSmall * sin(time * waveSpeed + waveBig) * waveAmp + waveAmp;
	
	return waveAnim;
}

float height(vec2 pos)
{
	float time = TIME;
	//time = timeScrub;
	return max(heightWaves(pos, time), heightBubble(pos, time));
}

void vertex() {
	// Called for every vertex the material is visible on.
	vec2 pos = VERTEX.xz;
	float k = height(pos);
	
	VERTEX += NORMAL * k;
	
	// Vertex Interpolated Normals
	// not able to create a function with a function parameter in gls
	vec2 off = vec2(0.05, 0.0);
	float normStrength = 1.0;
	NORMAL = normalize(
		vec3((height(pos - off) - height(pos + off)) * normStrength,
		2.0 * off.x,
		(height(pos - off.yx) - height(pos + off.yx)) * normStrength));
	
	vertHeight = k;
}

void fragment() {
	// Called for every pixel the material is visible on.
	//float k = vertHeight;
	
	ALBEDO = mix(color.gbg * 0.5, color.rgb, clamp((vertHeight * 2.0 + 0.6), 0.0, 1.0));
	//ROUGHNESS = clamp(pow(1.0 - vertHeight * 5.0, 4.0), 0.0, 1.0);
	ROUGHNESS = clamp((0.5 - vertHeight) * 0.5, 0.0, 1.0);
	//ROUGHNESS = 0.1;
	//ALBEDO = vec3(ROUGHNESS);
	//EMISSION = vec3(0.5);
	//METALLIC = 1.0;
	
	// Fragment Normals
	//vec3 vert = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	//float k = height(vert.xz);
	//float normStrength = 1.0;
	//NORMAL = heightToNormal(k, normStrength, VERTEX, NORMAL);
	
	//ALBEDO = color.xyz + k;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
