shader_type canvas_item;

uniform sampler2D screenTexture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D maskTexture;
//uniform sampler2D maskTexture1;
//uniform sampler2D maskTexture2;

void fragment() {
	//vec4 gb = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec4 col = textureLod(screenTexture, SCREEN_UV, 0.0);
	vec3 mask = textureLod(maskTexture, SCREEN_UV, 0.0).rgb;
	//vec3 mask1 = textureLod(maskTexture1, SCREEN_UV, 0.0).rgb;
	//vec3 mask2 = textureLod(maskTexture2, SCREEN_UV, 0.0).rgb;
	
	float ep = 0.1;
	//vec3 col1 = vec3(col.r, 0.0, 0.0) * (1.0 - ceil(mask));
	//vec3 col2 = vec3(0.0, col.g, 0.0) * (ceil(mask) - floor(mask));
	//vec3 col3 = vec3(0.0, 0.0, col.b) * floor(mask);
	vec3 col1 = vec3(col.r, 0.0, 0.0) * (1.0 - ceil(mask));
	vec3 col2 = vec3(0.0, col.g, 0.0) * (ceil(mask) - floor(mask));
	vec3 col3 = vec3(0.0, 0.0, col.b) * floor(mask);
	// col * identity matrix?
	
	//mat3 surf = mat3(
		//vec3(mask1, 0.0, 0.0),
		//vec3(0.0, mask2, 0.0),
		//vec3(0.0, 0.0, mask3)
		//);
	//col = vec4(surf * col.rgb, 1.0);
	
	col = vec4(floor(mask), 1.0);

	
    COLOR = col;
	//COLOR = vec4(vec3(dot(col.rgb, vec3(0.3, 0.59, 0.11))), col.w);
}