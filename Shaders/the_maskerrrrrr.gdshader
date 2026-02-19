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

uniform vec2 cam_pos = vec2(0.18146, 0.3492);
uniform vec2 cam_size = vec2(0.762914, 0.6);

void fragment() {
	vec2 uv_cam = UV + cam_pos;
	
	bool use_cam = false;
	float red_bonus;
	float green_bonus;
	float blue_bonus ;
	
	float regular_red;
	float regular_green;
	float regular_blue;
	
	red_bonus = texture(red_temp_masks, uv_cam).a;
	green_bonus = texture(green_temp_masks, uv_cam).a;
	blue_bonus = texture(blue_temp_masks, uv_cam).a;
	
	regular_red = texture(red_mask, uv_cam).a;
	regular_green = texture(green_mask, uv_cam).a;
	regular_blue = texture(blue_mask, uv_cam).a;
	
	
	COLOR = vec4(0.0);
	if (red_bonus > 0.0){
		COLOR = texture(red_texture, UV);
	}
	else if (green_bonus > 0.0){
		COLOR = texture(green_texture, UV);
	}
	else if (blue_bonus > 0.0){
		COLOR = texture(blue_texture, UV);
	}
	else if (regular_red > 0.0){
		COLOR = texture(red_texture, UV);
	}
	else if (regular_green > 0.0){
		COLOR = texture(green_texture, UV);
	}
	else {
		COLOR = texture(blue_texture, UV);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
