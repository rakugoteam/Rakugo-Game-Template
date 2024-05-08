shader_type canvas_item;

uniform float size : hint_range(0.0, 1.0) = 0.0;
uniform float wipe_direction = 1.0;
uniform bool invert_xy = false;

void fragment() {
	float which_axis = UV.x;
	if (invert_xy == true) {
		which_axis = UV.y;
	} 
	COLOR.a = (1.0 - step(size * wipe_direction, which_axis * wipe_direction));
}