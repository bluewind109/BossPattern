shader_type canvas_item;

uniform vec2 fragment_number = vec2(20, 20);
uniform float dissolve_state: hint_range(0, 1) = 1;

void fragment() {
	vec2 pixelFract = fract(UV * fragment_number);
	//COLOR.rgb = vec3(pixelFract, 0);
	float pixelDist = distance(pixelFract, vec2(0.5, 0.5));
	//COLOR.rgb = vec3(pixelDist, 0, 0);
	COLOR = texture(TEXTURE, UV);
	COLOR.a *= step(pixelDist, dissolve_state);
	// Left to right dissolve
	//COLOR.a *= step(pixelDist, dissolve_state + UV.x);
}
