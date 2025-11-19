// Credits: https://www.shadertoy.com/view/Mds3zn

const float ABBERATION_FACTOR = 0.1;

// Perlin Noise Function (2D)
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    
    vec2 u = f * f * (3.0 - 2.0 * f);
    
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float offsetFunction(float t, vec2 uv) {
    float amount = 1.0; // amount to return
    float intensity = 1.0; // intensity of the perturbation
    const float periods[8] = {0.3, 1.0, 13.0, 19.0, 20.0, 27.0, 30.0, 32.0};
    for (int i = 0; i < 8; i++) {
        amount *= 1.0 + intensity * sin(t * periods[i]);
    }
    
    float noiseFactor = noise(uv * 10.0 + t * 0.5); // Use Perlin noise to modulate effect
    return amount * 20.0 * cos(t) * noiseFactor;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
    float t = iTime * 0.1;
    vec2 uv = fragCoord.xy / iResolution.xy;
    float amount = offsetFunction(t, uv);
    
    float shift_r = noise(uv * 5.0 + t * 2.0) * 2.0 - 1.0; // Generate a random color shift
    float shift_g = noise(uv * 3.0 + t * 3.0) * 2.0 - 1.0; // Generate a random color shift
    float shift_b = noise(uv * 2.0 + t * 5.0) * 2.0 - 1.0; // Generate a random color shift
    
    vec3 col;
    col.r = texture(iChannel0, vec2(uv.x + ABBERATION_FACTOR * amount * shift_r / iResolution.x, uv.y)).r;
    col.g = texture(iChannel0, vec2(uv.x + ABBERATION_FACTOR * amount * shift_g / iResolution.x, uv.y)).g;
    col.b = texture(iChannel0, vec2(uv.x + ABBERATION_FACTOR * amount * shift_b / iResolution.x, uv.y)).b;
    
    fragColor = vec4(col, 1.0);
}
