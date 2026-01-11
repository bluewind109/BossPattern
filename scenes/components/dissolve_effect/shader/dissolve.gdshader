shader_type canvas_item;

uniform bool is_horizontal;

// Percentage of image that's been dissolved
uniform float progress: hint_range(0.0, 1.0);

// How far the pixels will float away before dissolving
uniform float float_dist = 6.0;

// Increase how far pixels can vertically differ from the "wave"
uniform float progress_rand_range = 0.6;

// Size of current texture
uniform vec2 texture_size = vec2(16, 16);

float random(vec2 uv) {
	return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 438.5453);
}

void fragment() {
	// float_dist but mapped to UV
	float v = float_dist / texture_size.y;

	// Adjusted progression + randomness
	float p = progress * (1.0 + (v + progress_rand_range) * 2.0)
	- v - progress_rand_range + random(UV) * progress_rand_range;

	if (is_horizontal)
	{
		// Individual pixel progression
		float q = smoothstep(p - v * 2.0, p, UV.x);

		// Map another pixel's UV to this one based on q
		float mapped_uv_x = UV.x + v - v * q * step(q, 1.0);

		// Increase transparency as particles begin to float away
		COLOR = texture(TEXTURE, vec2(mapped_uv_x, UV.y));
		COLOR.a -= 1.0 - q;
	}
	else
	{
		// Individual pixel progression
		float q = smoothstep(p - v * 2.0, p, UV.y);

		// Map another pixel's UV to this one based on q
		float mapped_uv_y = UV.y + v - v * q * step(q, 1.0);

		// Increase transparency as particles begin to float away
		COLOR = texture(TEXTURE, vec2(UV.x, mapped_uv_y));
		COLOR.a -= 1.0 - q;
	}
}
