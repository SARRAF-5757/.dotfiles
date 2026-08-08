const bool transparent = true;
const bool colorful = true;   // true = multicolor stars, false = white only
const float speed = 0.5;      // Speed of travel
const float luminosity = 0.7; // Glow Size/Intensity
const float brightness = 0.4; // Opacity
const float threshold = 0.15; // terminal contents luminance threshold to be considered background
const float repeats = 10.;    // divisions of grid
const float layers = 09.;     // number of layers

// star colours
const vec3 blue = vec3(51., 64., 195.) / 255.;
const vec3 cyan = vec3(117., 250., 254.) / 255.;
const vec3 white = vec3(255., 255., 255.) / 255.;
const vec3 yellow = vec3(251., 245., 44.) / 255.;
const vec3 red = vec3(247, 2., 20.) / 255.;

float luminance(vec3 color) {
    return dot(color, vec3(0.2126, 0.7152, 0.0722));
}

vec3 spectrum(vec2 pos) {
    // If colorful mode is off, return white
    if (!colorful) {
        return vec3(1.0);
    }
    
    pos.x *= 4.;
    vec3 outCol = vec3(0);
    if (pos.x > 0.) outCol = mix(blue, cyan, fract(pos.x));
    if (pos.x > 1.) outCol = mix(cyan, white, fract(pos.x));
    if (pos.x > 2.) outCol = mix(white, yellow, fract(pos.x));
    if (pos.x > 3.) outCol = mix(yellow, red, fract(pos.x));
    return 1. - (pos.y * (1. - outCol));
}

float N21(vec2 p) {
    p = fract(p * vec2(233.34, 851.73));
    p += dot(p, p + 23.45);
    return fract(p.x * p.y);
}

vec2 N22(vec2 p) {
    float n = N21(p);
    return vec2(n, N21(p + n));
}

mat2 scale(vec2 _scale) {
    return mat2(_scale.x, 0.0, 0.0, _scale.y);
}

float noise(in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = N21(i);
    float b = N21(i + vec2(1.0, 0.0));
    float c = N21(i + vec2(0.0, 1.0));
    float d = N21(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

vec3 stars(vec2 uv, float offset) {
    float timeScale = -(iTime * speed + offset) / layers;
    
    float trans = fract(timeScale);
    float newRnd = floor(timeScale);
    vec3 col = vec3(0.);

    uv -= vec2(0.5);
    uv = scale(vec2(trans)) * uv;
    uv += vec2(0.5);
    uv.x *= iResolution.x / iResolution.y;
    uv *= repeats;

    vec2 ipos = floor(uv);
    uv = fract(uv);

    vec2 rndXY = N22(newRnd + ipos * (offset + 1.)) * 0.9 + 0.05;
    float rndSize = N21(ipos) * 100. + 200.;
    vec2 j = (rndXY - uv) * rndSize;
    
    float sparkle = 1. / dot(j, j);
    sparkle *= luminosity;
    sparkle = min(sparkle, 1.0); 
    sparkle *= brightness;

    vec3 starColor = spectrum(fract(rndXY * newRnd * ipos));
    
    col += starColor * vec3(sparkle);
    col *= smoothstep(1., 0.8, trans);
    return col;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = fragCoord / iResolution.xy;
    vec3 col = vec3(0.);

    for (float i = 0.; i < layers; i++) {
        col += stars(uv, i);
    }

    vec4 terminalColor = texture(iChannel0, uv);

    if (transparent) {
        col += terminalColor.rgb;
    }

    float mask = 1.0 - step(threshold, luminance(terminalColor.rgb));
    vec3 blendedColor = mix(terminalColor.rgb, col, mask);

    fragColor = vec4(blendedColor, terminalColor.a);
}
