shader_type spatial;
render_mode unshaded, cull_disabled;
uniform sampler2D slash: repeat_disable;
uniform sampler2D highlight;
uniform sampler2D lifetime_tex;
uniform sampler2D erosion_curve;
uniform sampler2D erosion_tex;

uniform vec3 base: source_color;
uniform vec3 high_color: source_color;
varying float lifetime;
void vertex() {
	lifetime = INSTANCE_CUSTOM.y;
}

void fragment() {
	float inter_val = texture(lifetime_tex, vec2(lifetime)).r-1.0;
	float fade_out = texture(erosion_curve, vec2(lifetime)).r;
	float pixel = texture(slash, vec2(UV.x-inter_val, UV.y)).r;
	float erosion_pixel = texture(erosion_tex, vec2(UV.x-inter_val, UV.y)).r;
	float highlit = texture(highlight, vec2(UV.x-inter_val, UV.y)).r;
	
	ALPHA = pixel*float(UV.x-inter_val<=1.0)*smoothstep(fade_out, 1.0, erosion_pixel);
	ALBEDO = base*(pixel - highlit) + highlit * high_color;
}
