shader_type canvas_item;

uniform float size : hint_range(0.0, 1.0) = 0.0;
uniform float location_x : hint_range(-2.0, 2.0) = 0.0;
uniform float location_y : hint_range(-2.0, 2.0) = 0.0;
uniform float ratio_width : hint_range(-1.0, 2.0) = 1.0;
uniform float ratio_height : hint_range(-1.0, 2.0) = 1.0;
uniform bool invert = false;

void fragment() {
	float alpha1 = step(size + location_x, mix(0.5, UV.x, ratio_width));
	float alpha2 = step(size - location_x, mix(0.5, 1.0-UV.x, ratio_width));
	float alpha3 = step(size + location_y, mix(0.5, UV.y, ratio_height));
	float alpha4 = step(size - location_y, mix(0.5, 1.0-UV.y, ratio_height));
	float alpha_total = alpha1 * alpha2 * alpha3 * alpha4;
	if (invert == true) {
		alpha_total = 1.0 - alpha_total;
	}
	COLOR.a = alpha_total;
}