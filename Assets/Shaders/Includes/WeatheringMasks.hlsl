#ifndef WEATHERING_MASKS_INCLUDED
#define WEATHERING_MASKS_INCLUDED

float GetRustMask(
    float2 uv,
    float wearMask,
    float rustAmount
)
{
    // Independent rust distribution
    float rustNoise = FBM(uv * 19.0 + float2(13.7, 8.2));

    // Convert noise into rust coverage
    float rustCoverage = smoothstep(
        1.0 - rustAmount - 0.05,
        1.0 - rustAmount + 0.05,
        rustNoise
    );

    // Rust appears only on exposed metal
    return wearMask * rustCoverage;
}

#endif