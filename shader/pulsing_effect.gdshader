shader_type canvas_item;

instance uniform bool show_uv = false;
uniform float threshold: hint_range(0.0, 1.0, 0.1);

uniform float h: hint_range(-1.0, 1.0, 0.01);
uniform float hs: hint_range(-1.0, 1.0, 0.01);
uniform float v: hint_range(-1.0, 1.0, 0.01);
uniform float vs: hint_range(-1.0, 1.0, 0.01);

void fragment() {
	vec2 uv = vec2(UV.x, 1. - UV.y);

	float alpha = 1.0;
	float pi = 3.14;
	float frequency = 1.0;
	float speed = pi * frequency;
	alpha *= sin(TIME * speed) * 0.5 + 0.5;
	COLOR.r *= 1.0 / alpha;
	COLOR.g *= 1.0 / alpha;
	COLOR.b *= 1.0 / alpha;
	//COLOR = vec4(COLOR.rgb, alpha);

	if (show_uv)
	{
		COLOR = vec4(uv, 0.0, 1.0);
	}
}
