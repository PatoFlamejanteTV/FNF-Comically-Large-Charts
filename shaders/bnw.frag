#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

vec3 BlackAndWhiteThreshold(vec3 color, float threshold)
{
    float bright = 0.333333 * (color.r + color.g + color.b);
    float b = mix(0.0, 1.0, step(threshold, bright));
    return vec3(b);
}

void mainImage()
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;

    vec4 texColor = texture(iChannel0, uv);
    
    
    // get gray scale or luminescence
    float gray = 0.33 * (texColor.r + texColor.g + texColor.b);
    
    // mix white and black by the value of step(threshold, gray)
    float threshold = 0.5;
    if(gray > threshold)
    {
     // white
     texColor.rgb = vec3(1.0);   
    }
    else
    {
     // black
     texColor.rgb = vec3(0.0);
    }
    
    
    // Another way
    texColor = texture(iChannel0, uv);
    texColor.rgb = BlackAndWhiteThreshold(texColor.rgb, 0.5);

    // Output to screen
    fragColor = texColor;
}