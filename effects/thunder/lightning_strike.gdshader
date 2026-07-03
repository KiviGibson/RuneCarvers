// NOTE: Shader automatically converted from Godot Engine 4.7.stable's StandardMaterial3D.

shader_type spatial;
render_mode blend_mix, unshaded, depth_draw_opaque, cull_disabled, diffuse_burley, specular_schlick_ggx;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;

uniform vec3 uv1_scale;
uniform vec3 uv1_offset;


void vertex() {
	UV = UV * uv1_scale.xy + uv1_offset.yx;
}

void fragment() {
	vec2 base_uv = UV*ALPHA;
	
	vec4 albedo_tex = texture(texture_albedo, base_uv);
	ALBEDO = albedo.rgb * COLOR.rgb;
	
	ALPHA = float(albedo_tex.r > (1.0-COLOR.a)) * albedo_tex.r;
}
