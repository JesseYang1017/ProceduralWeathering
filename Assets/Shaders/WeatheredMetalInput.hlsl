#ifndef WEATHERED_METAL_INPUT_INCLUDED
#define WEATHERED_METAL_INPUT_INCLUDED

CBUFFER_START(UnityPerMaterial)
    float4 _BaseColor;
    //float _Metallic;
    //float _Smoothness;
    float _WearThreshold;
    float4 _PaintColor;
    float4 _MetalColor;
    float _PaintSmoothness;
    float _MetalSmoothness;
    float _EdgeWearStrength;
    
CBUFFER_END
// Geometry-aware wear mask
TEXTURE2D(_EdgeMask);
SAMPLER(sampler_EdgeMask);

struct Attributes
{
    float3 positionOS : POSITION;
    float3 normalOS   : NORMAL;
    float2 uv         : TEXCOORD0;
};

struct Varyings
{
    float4 positionCS : SV_POSITION;
    float3 positionWS : TEXCOORD0;
    half3 normalWS    : TEXCOORD1;
    float2 uv         : TEXCOORD2;
};

#endif