Shader "Custom/WeatheredMetal"
{
    Properties
    {
        [MainColor] _BaseColor ("Base Color", Color) = (0.7, 0.7, 0.7, 1)
        //_Metallic ("Metallic", Range(0, 1)) = 1.0
        //_Smoothness ("Smoothness", Range(0, 1)) = 0.8
        _WearThreshold ("Wear Threshold", Range(0, 1)) = 0.45
        _PaintColor ("Paint Color", Color) = (0.1, 0.25, 0.65, 1)
        _MetalColor ("Exposed Metal Color", Color) = (0.65, 0.65, 0.65, 1)
        _PaintSmoothness ("Paint Smoothness", Range(0, 1)) = 0.6
        _MetalSmoothness ("Metal Smoothness", Range(0, 1)) = 0.8
        _EdgeMask ("Edge Mask", 2D) = "black" {}
        _EdgeWearStrength ("Edge Wear Strength", Range(0, 0.5)) = 0.2
    }

    SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            "RenderType" = "Opaque"
            "Queue" = "Geometry"
        }

        Pass
        {
            Name "ForwardLit"
            Tags { "LightMode" = "UniversalForward" }

            Cull Back
            ZWrite On
            ZTest LEqual

            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            #include "WeatheredMetalInput.hlsl"

            // Reusable procedural functions
            #include "Includes/ProceduralNoise.hlsl"

            #include "WeatheredMetalForwardPass.hlsl"
            

            ENDHLSL
        }
    }

    FallBack "Hidden/Universal Render Pipeline/FallbackError"
}