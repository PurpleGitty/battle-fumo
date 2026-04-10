shader_type canvas_item;

uniform sampler2D noise_texture;
uniform float dissolve_value : hint_range(0.0, 1.1) = 0.0;
uniform vec4 glow_color : source_color = vec4(1.0, 0.5, 0.0, 1.0);
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 main_texture = texture(TEXTURE, UV);
	float noise = texture(noise_texture, UV).r;

	// Determine transparency based on noise vs dissolve_value
	float alpha = step(dissolve_value, noise);

	// Create a thin glowing edge
	float edge = step(dissolve_value - 0.05, noise) - alpha;

	vec4 final_color = mix(main_texture, glow_color, edge);
	COLOR = vec4(final_color.rgb, main_texture.a * alpha);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
