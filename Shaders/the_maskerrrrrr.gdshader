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
	//vec2 uv_cam = UV + cam_pos;
	vec2 uv_cam = UV + cam_pos + (0.5 * cam_size);
	//vec2 uv_cam = (UV - cam_pos) / cam_size; // moves with player
	
	bool use_cam = false;
	float red_bonus;
	float green_bonus;
	float blue_bonus ;
	
	float regular_red;
	float regular_green;
	float regular_blue;
	
	if(true){ //use camera
		red_bonus = texture(red_temp_masks, uv_cam).a;
		green_bonus = texture(green_temp_masks, uv_cam).a;
		blue_bonus = texture(blue_temp_masks, uv_cam).a;
		
		regular_red = texture(red_mask, uv_cam).a;
		regular_green = texture(green_mask, uv_cam).a;
		regular_blue = texture(blue_mask, uv_cam).a;
	}
	else {
		red_bonus = texture(red_temp_masks, UV).a;
		green_bonus = texture(green_temp_masks, UV).a;
		blue_bonus = texture(blue_temp_masks, UV).a;
		
		regular_red = texture(red_mask, UV).a;
		regular_green = texture(green_mask, UV).a;
		regular_blue = texture(blue_mask, UV).a;
	}
	
	//vec2 cam_pos = vec2(0.944371, 0.958643);
	//vec2 cam_size = vec2(0.762914, 0.6);
	
	//uv_cam = (UV - cam_pos) / cam_size;
	//uv_cam = UV - cam_pos;
	//uv_cam = (UV - vec2(0.2, 0.32)) * 1.4;
	//uv_cam = UV;
	//uv_cam = (UV + cam_pos) * cam_size;
	
	if(false){ // use camera
		COLOR = vec4(0.0);
		if (red_bonus > 0.0){
			COLOR = texture(red_texture, uv_cam);
		}
		else if (green_bonus > 0.0){
			COLOR = texture(green_texture, uv_cam);
		}
		else if (blue_bonus > 0.0){
			COLOR = texture(blue_texture, uv_cam);
		}
		else if (regular_red > 0.0){
			COLOR = texture(red_texture, uv_cam);
		}
		else if (regular_green > 0.0){
			COLOR = texture(green_texture, uv_cam);
		}
		else {
			COLOR = texture(blue_texture, uv_cam);
		}
	} else {
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
	
	
	
	//if (red_bonus > 0.0){
		//COLOR = texture(red_texture, UV);
	//}
	//else if (green_bonus > 0.0){
		//COLOR = texture(green_texture, UV);
	//}
	//else if (blue_bonus > 0.0){
		//COLOR = texture(blue_texture, UV);
	//}
	//else if (regular_red > 0.0){
		//COLOR = texture(red_texture, UV);
	//}
	//else if (regular_green > 0.0){
		//COLOR = texture(green_texture, UV);
	//}
	//else {
		//COLOR = texture(blue_texture, UV);
	//}
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
