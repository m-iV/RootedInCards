shader_type canvas_item;

uniform vec4 colour: source_color;
uniform float multiplier = 0.2;
uniform float softness = 0.2;
uniform float modulate = 0.2;

void fragment() {
	float value = distance(UV, vec2(0.5));
	COLOR = vec4(colour.rgb, smoothstep(multiplier, softness, value * modulate));
}
