#ifndef WEATHERED_METAL_FORWARD_PASS_INCLUDED
#define WEATHERED_METAL_FORWARD_PASS_INCLUDED

Varyings vert(Attributes input)
{
    Varyings output = (Varyings)0;

    output.positionCS =
        TransformObjectToHClip(input.positionOS);

    output.positionWS =
        TransformObjectToWorld(input.positionOS);

    output.normalWS =
        TransformObjectToWorldNormal(input.normalOS);

    output.uv = input.uv;

    return output;
}

half4 frag(Varyings input) : SV_Target
{
    // Initialize material surface properties
    SurfaceData surfaceData = (SurfaceData)0; //创建一个 SurfaceData 类型的变量，并把所有成员初始化为零。

    //surfaceData.albedo = _BaseColor.rgb;
    //surfaceData.metallic = _Metallic;
    //surfaceData.smoothness = _Smoothness;

    surfaceData.alpha = 1.0;
    surfaceData.occlusion = 1.0;
    surfaceData.normalTS = half3(0.0, 0.0, 1.0);

    // Initialize lighting input data
    InputData inputData = (InputData)0;

    // Fragment position in world space
    inputData.positionWS = input.positionWS;

    // Surface normal in world space
    inputData.normalWS =
        NormalizeNormalPerPixel(input.normalWS);

    // Direction from fragment to camera
    inputData.viewDirectionWS =
        GetWorldSpaceNormalizeViewDir(input.positionWS);

    // Shadow mapping coordinates
    inputData.shadowCoord =
        TransformWorldToShadowCoord(input.positionWS);

    // Ambient diffuse lighting from spherical harmonics
    inputData.bakedGI = SampleSH(inputData.normalWS); //根据当前表面的法线方向，计算它接收到的环境漫反射光照，返回 RGB 颜色。

    // Additional lighting inputs
    inputData.shadowMask = half4(1, 1, 1, 1);
    inputData.vertexLighting = half3(0, 0, 0);
    inputData.fogCoord = 0;

    // Screen-space UV
    inputData.normalizedScreenSpaceUV =
        GetNormalizedScreenSpaceUV(input.positionCS);

    // Debug: visualize the hash values
    float2 cell = floor(input.uv * 12.0);

    float noise = FBM(input.uv * 12.0);

    float edgeMask = SAMPLE_TEXTURE2D(
        _EdgeMask,
        sampler_EdgeMask,
        input.uv
    ).r;

    float combinedNoise =
        noise + edgeMask * _EdgeWearStrength;

    float wearMask = smoothstep(
        _WearThreshold - 0.05,
        _WearThreshold + 0.05,
        combinedNoise
    );

    // Blend paint and exposed metal colors. wearMask determines the blending factor 
    //between the two colors. A wearMask of 0 means fully painted, while a wearMask of 1 means fully exposed metal.
    surfaceData.albedo = lerp(
        _PaintColor.rgb,
        _MetalColor.rgb,
        wearMask
    );
    // Blend metallic properties
    surfaceData.metallic = lerp(
        0.0,
        1.0,
        wearMask
    );

    // Blend surface smoothness
    surfaceData.smoothness = lerp(
        _PaintSmoothness,
        _MetalSmoothness,
        wearMask
    );// Initial rust coverage on exposed metal

    float rustMask = GetRustMask(
        input.uv,
        wearMask,
        _RustAmount
    );

    // Blend rust color
    surfaceData.albedo = lerp(
        surfaceData.albedo,
        _RustColor.rgb,
        rustMask
    );

    // Rust is non-metallic
    surfaceData.metallic = lerp(
        surfaceData.metallic,
        0.0,
        rustMask
    );

    // Rust has a rougher surface
    surfaceData.smoothness = lerp(
        surfaceData.smoothness,
        _RustSmoothness,
        rustMask
    );
    
    // Debug: visualize baked edge mask
    return UniversalFragmentPBR(inputData, surfaceData);
    }
#endif