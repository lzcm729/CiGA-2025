shader_type spatial;
uniform vec3 color : source_color = vec3( 1, 1, 1 );

void fragment() {
	ALBEDO = color;
	ALPHA = 0.4;
}