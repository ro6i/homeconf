
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec3 col = texture(iChannel0, uv).rgb;

    if (col.r < 0.1) {
      vec3 amberColor = vec3(0.15, 0.11, 0.01) * 6;

      float bgGlowIntensity = 0.6;
      float bgGlow = bgGlowIntensity * smoothstep(1.2, 0.0, length(uv - 0.5));
      vec3 backgroundColor = amberColor * bgGlow * 0.1;

      vec3 color = mix(backgroundColor, col, 0.8);

      fragColor = vec4(color, 1.0);
    } else {
      fragColor = vec4(col, 1.0);
    }
}
