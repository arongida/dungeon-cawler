shader_type canvas_item;

uniform vec4 flash_color : source_color;
uniform float flash_value : hint_range(0.0, 1.0, 0.1);

void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	vec4 final_color = mix(texture_color, flash_color, flash_value);
	final_color.a = texture_color.a * COLOR.a; // Apply modulate alpha
	COLOR = final_color;
}