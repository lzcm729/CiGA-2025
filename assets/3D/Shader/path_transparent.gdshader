shader_type spatial;
uniform vec3 color : source_color = vec3( 1, 1, 1 );
uniform float alpha : hint_range(0.0, 1.0) = 0.4;
void fragment() {
	ALBEDO = color;
	ALPHA = alpha;
}