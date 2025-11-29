// Original shader collected from: https://www.shadertoy.com/view/WsVSzV
// Licensed under Shadertoy's default since the original creator didn't provide any license. (CC BY NC SA 3.0)
// Slight modifications were made to give a green-ish effect.

float warp = 0.25; // simulate curvature of CRT monitor
float scan = 0.50; // simulate darkness between scanlines

// Toggle transparency support here
bool use_transparency = true; 

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    // squared distance from center
    vec2 uv = fragCoord / iResolution.xy;
    vec2 dc = abs(0.5 - uv);
    dc *= dc;
    
    // warp the fragment coordinates
    uv.x -= 0.5; uv.x *= 1.0 + (dc.y * (0.3 * warp)); uv.x += 0.5;
    uv.y -= 0.5; uv.y *= 1.0 + (dc.x * (0.4 * warp)); uv.y += 0.5;

    // sample inside boundaries, otherwise set to empty/black
    if (uv.y > 1.0 || uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0)
    {
        // If transparency is on, make the outside area invisible.
        // If off, keep it solid black (classic CRT bezel look).
        fragColor = vec4(0.0, 0.0, 0.0, use_transparency ? 0.0 : 1.0);
    }
    else
    {
        // determine if we are drawing in a scanline
        float apply = abs(sin(fragCoord.y) * 0.5 * scan);
        
        // sample the texture (grab alpha too!)
        vec4 texColor = texture(iChannel0, uv);
        vec3 color = texColor.rgb;
        vec3 tealTint = vec3(0.0, 0.8, 0.6); // teal color

        // mix the sampled color with the teal tint based on scanline intensity
        vec3 processedColor = mix(color * tealTint, vec3(0.0), apply);
        
        // determine final alpha
        float alpha = use_transparency ? texColor.a : 1.0;

        fragColor = vec4(processedColor, alpha);
    }
}
