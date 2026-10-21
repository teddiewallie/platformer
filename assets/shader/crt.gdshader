shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

uniform float line_strength : hint_range(0.0, 1.0) = 0.2;
uniform float line_height : hint_range(2.0, 12.0) = 5.0;
uniform float line_thickness : hint_range(0.1, 0.9) = 0.8;
uniform float brightness : hint_range(0.5, 1.5) = 1.15;

uniform float bleed_strength : hint_range(0.0, 1.0) = 0.1;
uniform float bleed_radius : hint_range(0.5, 4.0) = 1;

uniform float noise_strength : hint_range(0.0, 0.2) = 0.045;
uniform float noise_speed : hint_range(0.0, 10.0) = 1.2;

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 centered = uv * 2.0 - 1.0;

    vec2 px = SCREEN_PIXEL_SIZE * bleed_radius;

    vec4 screen = texture(screen_texture, uv);

    vec3 bleed = vec3(0.0);
    bleed += texture(screen_texture, uv + vec2(px.x, 0.0)).rgb;
    bleed += texture(screen_texture, uv - vec2(px.x, 0.0)).rgb;
    bleed += texture(screen_texture, uv + vec2(0.0, px.y)).rgb;
    bleed += texture(screen_texture, uv - vec2(0.0, px.y)).rgb;
    bleed += texture(screen_texture, uv + px).rgb;
    bleed += texture(screen_texture, uv - px).rgb;
    bleed += texture(screen_texture, uv + vec2(px.x, -px.y)).rgb;
    bleed += texture(screen_texture, uv + vec2(-px.x, px.y)).rgb;
    bleed /= 8.0;

    // Blend the neighboring pixels into the original image
    screen.rgb = mix(screen.rgb, bleed, bleed_strength);

    // Scanlines
    float line = step(
        line_thickness,
        fract(FRAGCOORD.y / line_height)
    );
    screen.rgb *= mix(1.0 - line_strength, 1.0, line);

    screen.rgb *= brightness;

    // CRT static: independently reshuffled noise every frame
    vec2 cell = floor(SCREEN_UV / (SCREEN_PIXEL_SIZE * 2.0));
    float frame = floor(TIME * 30.0);

    vec2 p = cell + vec2(frame * 17.0, frame * 31.0);
    vec3 seed = fract(vec3(p.xyx) * vec3(0.1031, 0.1030, 0.0973));
    seed += dot(seed, seed.yxz + 33.33);
    float noise = fract((seed.x + seed.y) * seed.z);

    screen.rgb += (noise - 0.5) * noise_strength;
    screen.rgb = clamp(screen.rgb, 0.0, 1.0);

    COLOR = screen;
}
