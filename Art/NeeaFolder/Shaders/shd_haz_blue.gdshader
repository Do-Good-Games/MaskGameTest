shader_type spatial;

render_mode world_vertex_coords, shadows_disabled; //specular_toon;

uniform vec4 color : source_color = vec4(1.0);
uniform float rough : hint_range(0, 1) = 0.1;
//uniform float rim : hint_range(0, 1) = 0.2;
uniform float noise_size = 10.0;
uniform float wave_freq = 0.4;
uniform float wave_height = 0.3;
uniform float foam = 5.0;
uniform sampler2D noise;

varying float _height;

float wave(vec2 pos)
{
	pos += texture(noise, pos / noise_size).x * 2.0 - 1.0;
	vec2 st = 1.0 - abs(sin(pos));
	return pow(1.0 - pow(st.x * st.y, 0.65), 4.0);
}

float height(vec2 pos, float time)
{
	//vec2 off = 0.01 * cos(pos + time);
	//return texture(noise, (pos / noise_size) + off).x;
	float adj = 0.8;
	float k = 0.0;
	float wf = wave_freq;
	float wh = wave_height;
	for(int i = 0; i < 4; ++i)
	{
		k += wave((pos + time * float((i & 1) * 2 - 1) * wf)) * wh;
		wf /= adj;
		wh *= adj;
	}
	return k;
}

void vertex() {
	// Called for every vertex the material is visible on.
	//VERTEX.y += cos(TIME * 5.0 + VERTEX.x * TAU * 2.0) * 0.2;
	
	//float height = texture(noise, VERTEX.xz / 2.0 + 0.5).x * 0.2;
	//VERTEX.y += height;
	
	vec2 pos = VERTEX.xz;
	float k = height(pos, TIME);
	VERTEX.y += k;
	//NORMAL = normalize(vec3(k));
	NORMAL = normalize(vec3(k - height(pos + vec2(0.1, 0.0), TIME), 0.1, k - height(pos + vec2(0.0, 0.1), TIME)));
	_height = k;
}

void fragment() {
	// Called for every pixel the material is visible on.
	//vec3 col = vec3(cos(UV.x * TAU * 5.0));
	ALBEDO = color.rgb + pow(_height, foam) * foam;
	//METALLIC = 0.0;
	ROUGHNESS = rough;
	//RIM = rim; // not seeing any affect
	//EMISSION = ALBEDO;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
