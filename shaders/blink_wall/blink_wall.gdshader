shader_type spatial;
uniform vec3 player1_pos;
uniform vec3 player2_pos;
uniform sampler2D noise;
uniform float noise_y;
uniform float elevation;

varying vec3 frag_world_pos;
varying float height;

void vertex() {
    height = length(MODEL_MATRIX[1].xyz);
    frag_world_pos = NODE_POSITION_WORLD + (mat3(MODEL_MATRIX)*VERTEX);
}

void fragment() {
    float a1 = clamp(0.5/distance(frag_world_pos.xz, player1_pos.xz), 0.1, 1.1) - 0.1;
    float a2 = clamp(0.5/distance(frag_world_pos.xz, player2_pos.xz), 0.1, 1.1) - 0.1;
    a1 *= dot(texture(noise, frag_world_pos.xz/20.0 + vec2(0.0, noise_y)).rgb, vec3(1.0, 1.0, 1.0));
    a2 *= dot(texture(noise, frag_world_pos.xz/20.0 + vec2(0.0, noise_y)).rgb, vec3(1.0, 1.0, 1.0));

    vec4 color1 = vec4(1.0, 0.25, 0.25, a1);
    vec4 color2 = vec4(0.25, 1.0, 0.25, a2);

    float total_alpha = (color1.a + color2.a)*(5.0/max(abs(height - (frag_world_pos.y - elevation)), 0.001));
	total_alpha -= (frag_world_pos.y - elevation)*height*0.2;

    EMISSION = (color1.rgb*color1.a + color2.rgb*color2.a)*total_alpha;
    ALBEDO = (color1.rgb*color1.a + color2.rgb*color2.a)*total_alpha;
    ALPHA = clamp(total_alpha, 0.0, 1.0);
}
