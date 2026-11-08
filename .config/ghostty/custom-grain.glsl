// A simple, fast pseudo-random function
float random(vec2 uv) {
    return fract(sin(dot(uv.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;

    // 1. Fetch your base texture or color
    vec3 baseColor = vec3(0.2, 0.1, 0.01) / 4;
    vec3 col = texture(iChannel0, uv).rgb;


    // 2. Generate noise using UVs and time
    float noise = random(uv);

    // 3. Keep it extremely subtle (e.g., max 2% opacity)
    float noiseIntensity = 0.06;

    // 4. Mix the noise into the base color (can add or multiply)
    vec3 finalColor = baseColor + (noise - 0.8) * noiseIntensity;

    fragColor = vec4(mix(finalColor, col, 0.9), 1.0);
}
