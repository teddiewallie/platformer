shader_type canvas_item;

uniform float offset_amount : hint_range(0.0, 4.0) = 1.0;
uniform float pulse_speed : hint_range(0.1, 3.0) = 1.0;
uniform float ghost_strength : hint_range(0.0, 1.0) = 0.35;
uniform float variation_speed : hint_range(0.1, 3.0) = 0.4;

void fragment() {
    // Irregular pulse: overlapping waves break up the predictable rhythm
    float wave1 = sin(TIME * pulse_speed);
    float wave2 = sin(TIME * pulse_speed * 0.63 + 1.7);
    float wave3 = sin(TIME * pulse_speed * 1.37 + 4.2);

    float pulse = (wave1 * 0.5 + wave2 * 0.3 + wave3 * 0.2 + 1.0) * 0.5;
    pulse = smoothstep(0.0, 1.0, pulse);

    float cycle = TIME * variation_speed;
    float segment = floor(cycle);
    float blend = fract(cycle);
    blend = blend * blend * (3.0 - 2.0 * blend);

    float offset_a = 1.0 + 2.0 * fract(sin(segment * 78.233) * 43758.5453);
    float offset_b = 1.0 + 2.0 * fract(sin((segment + 1.0) * 78.233) * 43758.5453);

    float dynamic_offset = mix(offset_a, offset_b, blend) * offset_amount;

    vec2 pixel = TEXTURE_PIXEL_SIZE;
    vec2 offset = vec2(dynamic_offset * pulse, 0.0) * pixel;

    vec4 color = texture(TEXTURE, UV);
    vec4 left = texture(TEXTURE, UV - offset);
    vec4 right = texture(TEXTURE, UV + offset);

    color.rgb = mix(
        color.rgb,
        (color.rgb + left.rgb + right.rgb) / 3.0,
        ghost_strength * pulse
    );

    COLOR = color;
}
