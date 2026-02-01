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
	if (texture(red_mask, UV).a > 0.0){
		COLOR = texture(red_texture, UV);
	}
	else if (texture(green_mask, UV).a > 0.0 || texture(green_temp_masks, UV).a > 0.0){
		COLOR = texture(green_texture, UV);
	}
	else if (texture(blue_mask, UV).a > 0.0 || texture(blue_temp_masks, UV).a > 0.0){
		COLOR = texture(blue_texture, UV);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
