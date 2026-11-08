const vec3 LUMINANCE_COEFFICIENTS = vec3(0.2126, 0.7152, 0.0722);

float lum(vec3 color) {
  return dot(color, LUMINANCE_COEFFICIENTS);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 uv = fragCoord.xy / iResolution.xy;

  vec4 color = texture(iChannel0, uv);
  // vec3 col = color.rgb;

  vec2 cursorMin = iCurrentCursor.xy + vec2(0.0, -iCurrentCursor.w);
  vec2 cursorMax = iCurrentCursor.xy + vec2(iCurrentCursor.z, 0.0);

  float epsilon = 1.5;

  // bool isInside = fragCoord.x >= cursorMin.x && fragCoord.x <= cursorMax.x && fragCoord.y >= cursorMin.y && fragCoord.y <= cursorMax.y;
  // bool isInside = fragCoord.x >= 100.0 && fragCoord.x <= 150.0 && fragCoord.y >= 200.0 && fragCoord.y <= 220.0;
  // bool isOn = (fragCoord.x == cursorMin.x || fragCoord.x == cursorMax.x) && (fragCoord.y == cursorMin.y || fragCoord.y == cursorMax.y);
  float xl = step(abs(distance(fragCoord.x, cursorMin.x)), epsilon);
  float xr = step(abs(distance(fragCoord.x, cursorMax.x)), epsilon);
  float yb = step(abs(distance(fragCoord.y, cursorMin.y)), epsilon);
  float yt = step(abs(distance(fragCoord.y, cursorMax.y)), epsilon);


  if (iCursorVisible != 0 && (
      ((abs(distance(fragCoord.x, cursorMin.x)) < epsilon || abs(distance(fragCoord.x, cursorMax.x)) < epsilon) && fragCoord.y >= cursorMin.y && fragCoord.y <= cursorMax.y) ||
      ((abs(distance(fragCoord.y, cursorMin.y)) < epsilon || abs(distance(fragCoord.y, cursorMax.y)) < epsilon) && fragCoord.x >= cursorMin.x && fragCoord.x <= cursorMax.x)
    )
  ) {
    // vec2 texelSize = 1.0 / iResolution.xy;
    vec2 uvSample1 = vec2(iCurrentCursor.x - 1.0, iCurrentCursor.y - 2.0).xy / iResolution.xy;
    vec2 uvSample2 = vec2(iCurrentCursor.x + iCurrentCursor.z + 1, iCurrentCursor.y - 5.0).xy / iResolution.xy;
    vec3 sampleColor = mix(texture(iChannel0, uvSample1).rgb, texture(iChannel0, uvSample2).rgb, 0.5);
    // fragColor = vec4(mix(vec3(0.2 + (1 - uv.y - uv.x) * 0.7, 0.2 + uv.y * 0.8, 0.2 + uv.x + 0.8), 1.0 - sampleColor, 0.2), 1.0);
    float sampleLum = lum(sampleColor);
    fragColor =  (sampleLum > 0.1) ? vec4(vec3(0.2, 1.0 - step(sampleLum, 0.1), 0.5), 0.2) : vec4(vec3(0.10, 0.25, 0.05), 1.0);

    // fragColor = vec4(vec3(0.1, 0.25, 0.0), 0.991);
  } else {
    fragColor = color;
  }
}
