shader_type canvas_item;

uniform float size : hint_range(0.0, 1.0) = 0.4;
uniform float size_ratio : hint_range(0.0, 3.0) = 1.0;
uniform float location_x : hint_range(-1.0, 2.0) = 0.5;
uniform float location_y : hint_range(-1.0, 2.0) = 0.5;
uniform bool invert = false;

void fragment() {
	float ratio = 1.0 / size_ratio;
	float dist = distance(vec2(location_x, location_y), vec2(mix(0.5, UV.x, ratio), UV.y));
	float alpha_total = (1.0 - step(size, dist));
	if (invert == true) {
		alpha_total = 1.0 - alpha_total;
	}
	COLOR.a = alpha_total;
}