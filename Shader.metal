//
//  File.metal
//  CanYouHearMe
//
//  Created by Valery Zazulin on 31.01.25.
//

#include <metal_stdlib>
using namespace metal;

// Wave (like underwater)
[[stitchable]]
float2 waveHoriz(float2 pos, float t, float2 size, float nearT, float nearPosX, float theEnd) {
    
    pos.y += sin(t * nearT + pos.x / nearPosX) * theEnd;

    return pos;
}

// Colorful SINE 🌊🌊🌊🌊🌊🌊🌊🌊🌊🌊🌊

[[stitchable]] float2 slowSine(float2 pos, float time, float speed, float smoothing, float strength, float2 size) {
    float2 uv = pos / size;
    
    if (uv.y < 0.5) {
        pos.y += sin(time * speed - pos.x / smoothing) * strength - sin(time * speed + pos.x / smoothing);
    } else {
        pos.y += sin(time * speed - pos.x / smoothing) * strength * (-1) - sin(time * speed + pos.x / smoothing) * (-1);
    }
    return pos;
}

// brighter BW
[[stitchable]] half4 grayShades(float2 position, half4 color, float opacity) {
    half luminance = dot(color.rgb, half3(0.499, 0.587, 0.114));
    half3 grayscaleColor = half3(luminance, luminance, luminance);
    
    half3 blendedColor = mix(color.rgb, grayscaleColor, opacity);
    
    return half4(blendedColor, color.a);
}

// brighter Red
[[stitchable]] half4 brighterRedShades(float2 position, half4 color, float opacity) {
    half luminance = dot(color.rgb, half3(0.4, 0.587, 0.214));
    half3 redTint = half3(luminance, 0.0, 0.0);
    
    half3 blendedColor = mix(color.rgb, redTint, opacity);
    
    return half4(blendedColor, color.a);
}

// Apple's Red / Indigo Color ==== DEMO TRY
[[stitchable]] half4 indingoShades(float2 position, half4 color, float opacity) {
        half luminance = dot(color.rgb, half3(0.4, 0.587, 0.214));

//        half3 targetRed = half3(245.0 / 255.0, 135.0 / 255.0, 130.0 / 255.0);
    half3 targetIndigo = half3(160.0 / 255.0, 0.0 / 255.0, 245.0 / 255.0);

//        half3 redShades = mix(half3(0.0, 0.0, 0.0), targetRed, luminance);
    half3 indigoShades = mix(half3(0.0, 0.0, 0.0), targetIndigo, luminance);
//        half3 blendedColor = mix(color.rgb, redShades, opacity);
    half3 blendedColor = mix(color.rgb, indigoShades, opacity);

        return half4(blendedColor, color.a);
}
