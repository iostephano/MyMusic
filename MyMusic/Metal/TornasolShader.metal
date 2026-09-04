//
//  TornasolShader.metal
//  MyMusic
//
//  Created by Stephano Portella on 29/07/25.
//

#include <metal_stdlib>
using namespace metal;

struct VertexOut {
    float4 position [[position]];
    float2 uv;
};

vertex VertexOut vertex_main(uint vertexID [[vertex_id]]) {
    float2 positions[6] = {
        float2(-1.0,  1.0),
        float2(-1.0, -1.0),
        float2( 1.0, -1.0),
        float2(-1.0,  1.0),
        float2( 1.0, -1.0),
        float2( 1.0,  1.0)
    };

    float2 pos = positions[vertexID];
    VertexOut out;
    out.position = float4(pos, 0, 1);
    out.uv = pos * 0.5 + 0.5;
    return out;
}

float noise(float2 p) {
    return fract(sin(dot(p, float2(12.9898, 78.233))) * 43758.5453);
}

fragment float4 tornasol_fragment(VertexOut in [[stage_in]],
                                  constant float &time [[buffer(0)]]) {
    float2 uv = in.uv;

    // Posición relativa desde esquina superior izquierda
    float2 center = float2(0.0, 1.0);
    float2 pos = uv - center;

    // Coordenadas polares desde esquina
    float dist = length(pos);
    float angle = atan2(pos.y, pos.x);

    // Generar bandas animadas tipo rayo
    float stripes = sin(angle * 10.0 - time * 2.0) * 0.5 + 0.5;
    float radialFade = smoothstep(0.8, 0.0, dist);

    // Efecto de ruido para ondulación
    float2 warped = pos * 20.0 + time * 0.5;
    float ripple = noise(warped) * 0.4 + 0.6;

    // Color tornasolado animado
    float3 baseColor = float3(1.0, 0.5 + sin(time + dist * 4.0), 0.8 + 0.2 * cos(time + angle * 2.0));
    float3 finalColor = baseColor * stripes * radialFade * ripple;

    return float4(finalColor, radialFade * 0.8); // transparencia incluida
}
