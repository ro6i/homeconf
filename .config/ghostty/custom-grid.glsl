const vec2 CELL_SIZE = vec2(14.0, 24.0);
// const vec4 GRID_COLOR = vec4(0.05, 0.03, 0.0, 0.8);
// const float THICKNESS = 2.0;
const vec4 GRID_COLOR = vec4(0.003, 0.002, 0.0, 0.99);
const float THICKNESS = 1.0;

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
  vec2 uv = fragCoord.xy / iResolution.xy;

  vec4 color = texture(iChannel0, uv);

  if (color.r != 0.0 || color.g != 0.0 || color.b != 0.0) {

  // Invert the Y-coordinate to switch from GLSL standard (bottom-left)
  // to standard screen/window coordinates (top-left aligned).
  vec2 topLeftCoord = vec2(fragCoord.x - 1, iResolution.y - fragCoord.y - 1);

  // Get the pixel's local position within the current character cell
  vec2 cellLocal = mod(topLeftCoord, CELL_SIZE);

  // Check if the pixel falls on the left-top borders of the cell
  // or the right-bottom edges (which double as the adjacent cell's start)
  // bool isBorderX = (cellLocal.x < THICKNESS) || (CELL_SIZE.x - cellLocal.x <= THICKNESS);
  // bool isBorderY = (cellLocal.y < THICKNESS) || (CELL_SIZE.y - cellLocal.y <= THICKNESS);
  bool isBorderX = (cellLocal.x < THICKNESS);
  bool isBorderY = (cellLocal.y < THICKNESS);

  if (isBorderX || isBorderY)
  // if ((isBorderX || isBorderY) && !((isBorderX && isBorderY)))
  // if (isBorderX && isBorderY) // dots
  // if (isBorderX)
  {
      // fragColor = mix(color, GRID_COLOR, 0.5);
      fragColor = mix(color, GRID_COLOR, 0.8);
  } else {
    fragColor = color;
  }
  } else {
    fragColor = color;
  }
}
