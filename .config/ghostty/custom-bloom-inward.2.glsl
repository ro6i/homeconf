
// Standard digital video coefficients (Rec. 709) for human eye perception
const vec3 LUMINANCE_COEFFICIENTS = vec3(0.2126, 0.7152, 0.0722);

vec3 adjustSaturation(vec3 color, float saturation) {
  // Calculate the grayscale luminance of the color
  float luminance = dot(color, LUMINANCE_COEFFICIENTS);
  vec3 grayscale = vec3(luminance);

  // Mix between the grayscale and original color
  // Saturation > 1.0 extrapolates past the original color to boost it
  return mix(grayscale, color, saturation);
}

float lum(vec3 color) {
  return dot(color, LUMINANCE_COEFFICIENTS);
}

bool isColorBright(vec3 color, float threshold) {
    float luminance = dot(color, LUMINANCE_COEFFICIENTS);
    return luminance > threshold;
}

bool isColorDark(vec3 color, float threshold) {
    float luminance = dot(color, LUMINANCE_COEFFICIENTS);
    return luminance < threshold;
}

vec3 hsl2rgb(in vec3 c) {
    vec3 rgb = clamp(abs(mod(c.x * 6.0 + vec3(0.0, 4.0, 2.0), 6.0) - 3.0) - 1.0, 0.0, 1.0);
    return c.z + c.y * (rgb - 0.5) * (1.0 - abs(2.0 * c.z - 1.0));
}

vec3 rgb2hsl(in vec3 c) {
    float h = 0.0, s = 0.0, l = 0.0;
    float r = c.r, g = c.g, b = c.b;
    float cMin = min(r, min(g, b));
    float cMax = max(r, max(g, b));
    l = (cMax + cMin) / 2.0;

    if (cMax > cMin) {
        float d = cMax - cMin;
        s = l < 0.5 ? d / (cMax + cMin) : d / (2.0 - cMax - cMin);
        if (r == cMax) {
            h = (g - b) / d + (g < b ? 6.0 : 0.0);
        } else if (g == cMax) {
            h = (b - r) / d + 2.0;
        } else {
            h = (r - g) / d + 4.0;
        }
        h /= 6.0;
    }
    return vec3(h, s, l);
}

vec3 mkBaseHsl(in vec3 col) {
  vec3 hslColor = rgb2hsl(col);
  // hslColor.x -= 0.032;
  if (hslColor.x > 0.032) {
    hslColor.x -= (hslColor.x < (50.0 / 360.0) ? 0.035 : 0.032);
  }
  if (hslColor.x > 0.8) {
    hslColor.y = clamp(hslColor.y * 1.1, 0.0, 1.0);
  }
  // hslColor.z = hslColor.z * (hslColor.x < 0.5 ? 0.535 : 0.45);
  // float dampen = 1.0;
  // if (hslColor.x <= (40.0 / 360.0)) {
  //   dampen = 0.35;
  // } else {
  //   dampen = 0.35;
  // }
  // hslColor.z = hslColor.z * dampen;
  return hslColor;
}


void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 uv = fragCoord.xy / iResolution.xy;
  vec2 texelSize = 1.0 / iResolution.xy;

    vec3 col = texture(iChannel0, uv).rgb;

    // sample 4 cardinal neighbors shifted by exactly 1 pixel
    vec3 n = texture(iChannel0, uv + vec2(0.0, texelSize.y)).rgb;
    vec3 s = texture(iChannel0, uv - vec2(0.0, texelSize.y)).rgb;
    vec3 e = texture(iChannel0, uv + vec2(texelSize.x, 0.0)).rgb;
    vec3 w = texture(iChannel0, uv - vec2(texelSize.x, 0.0)).rgb;

    float lc = lum(col);
    float dn = lc - lum(n);
    float ds = lc - lum(s);
    float de = lc - lum(e);
    float dw = lc - lum(w);
    float dl = 0.05;


    if (isColorBright(col, 0.10)) {
      vec3 shadeColorHsl = mkBaseHsl(col);
      // shadeColorHsl.x -= 0.010;
      // shadeColorHsl.y *= 0.9;
      // shadeColorHsl.z *= 0.88;
      shadeColorHsl.x += mod(fragCoord.x + fragCoord.y, 2.0) > 0.5 ? 0.01 : 0.0;
      shadeColorHsl.y = clamp(shadeColorHsl.y * (mod(fragCoord.x + fragCoord.y, 8.0) > 4.0 ? 1.1 : 1.0), 0.0, 1.0);
      shadeColorHsl.z *= mod(fragCoord.x + fragCoord.y, 2.0) <= 0.5 ? 1.0 : 0.74;
      vec3 shadeColor = hsl2rgb(shadeColorHsl);

      // if (abs(dn) > dl || abs(ds) > dl || abs(de) > dl || abs(dw) > dl) {
      if ((abs(dn) + abs(ds) + abs(de) + abs(dw)) > (2 * dl)) {
        vec3 finalColor1 = shadeColor;
        fragColor = vec4(finalColor1, 1.0);
      } else {
        fragColor = vec4(col, 1.0);
      }
    } else {
      if (isColorDark(col, 0.05)) {
        float diff = abs(length(col - n)) + abs(length(col - s)) + abs(length(col - e)) + abs(length(col - w));

        vec3 finalColor = col;

      if ((abs(dn) + abs(ds) + abs(de) + abs(dw)) > (2 * dl)) {
          finalColor = n * 0.25 + s * 0.25 + e * 0.25 + w * 0.25;
          finalColor = mkBaseHsl(finalColor);
          finalColor.z *= 0.05;
          finalColor = hsl2rgb(finalColor);
          // finalColor *= 0.1;

          fragColor = vec4(finalColor, 1.0);
        // fragColor = vec4(0.0, 0.5, 0.0, 1.0);
        } else {
          fragColor = vec4(col, 1.0);
        }
      } else {
        fragColor = vec4(col, 1.0);
      }
    }
}
