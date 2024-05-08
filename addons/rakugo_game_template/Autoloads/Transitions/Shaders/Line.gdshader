shader_type canvas_item;

uniform float num_lines = 20.;
uniform float y_threshold: hint_range(0.0, 1.0) = 0.5;
uniform vec4 line_color_a: source_color = vec4(1.);
uniform vec4 line_color_b: source_color = vec4(0., 0., 0., 1.0);

void fragment() {
	vec2 tiled_uv = vec2(fract(UV.x * num_lines / 2.), UV.y);
	if (tiled_uv.x < 0.5){
		if(tiled_uv.y < y_threshold){
			COLOR = line_color_a;
		} else {
			COLOR = vec4(0.0);
		}
	} else {
		if (tiled_uv.y > 1. - y_threshold){
			COLOR = line_color_b;
		} else {
			COLOR = vec4(0.0);
		}
	}
}