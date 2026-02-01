shader_type canvas_item;
uniform sampler2D red_texture;
uniform sampler2D red_mask;

uniform sampler2D green_texture;
uniform sampler2D green_mask;

uniform sampler2D blue_texture;
uniform sampler2D blue_mask;
uniform sampler2D red_temp_masks;
uniform sampler2D green_temp_masks;
uniform sampler2D blue_temp_masks;


void fragment() {
	COLOR = vec4(0.0);
	float red_bonus = 0.0;
	float green_bonus = 0.0;
	float blue_bonus = 0.0;
	
	red_bonus = texture(red_temp_masks, UV).a;
	if (red_bonus <= 0.0) {
		green_bonus = texture(green_temp_masks, UV).a;
	}
	if (green_bonus <= 0.0){
		blue_bonus = texture(blue_temp_masks, UV).a;
	}
	
	float red_alpha = max(texture(red_mask, UV).a, red_bonus);
	float blue_alpha = max(texture(blue_mask, UV).a, blue_bonus);
	float green_alpha = max(texture(green_mask, UV).a, green_bonus);
	
	vec4 red_color = texture(red_texture, UV) * red_alpha;
	vec4 green_color = texture(green_texture, UV) * green_alpha;
	vec4 blue_color = texture(blue_texture, UV) * blue_alpha;
	
	COLOR = red_color + green_color + blue_color;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
