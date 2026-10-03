#ifndef PROCEDURAL_NOISE_INCLUDED
#define PROCEDURAL_NOISE_INCLUDED

float Hash21(float2 p)
{
    p = frac(p * float2(123.34, 345.45));

    p += dot(p, p + 34.345); //让坐标的两个分量相互影响，进一步混合数值

    return frac(p.x * p.y);
}

float ValueNoise(float2 p)
{
    // Integer cell coordinates
    float2 i = floor(p);

    // Position inside the cell [0, 1)
    float2 f = frac(p);

    // Smooth interpolation weights
    float2 u = f * f * (3.0 - 2.0 * f);

    // Random values at four corners
    float a = Hash21(i);
    float b = Hash21(i + float2(1, 0));
    float c = Hash21(i + float2(0, 1));
    float d = Hash21(i + float2(1, 1));

    // Bilinear interpolation
    float bottom = lerp(a, b, u.x);
    float top = lerp(c, d, u.x);

    return lerp(bottom, top, u.y);
}

float FBM(float2 p)
{
    float value = 0.0;
    float amplitude = 0.5;

    for (int i = 0; i < 4; i++)
    {
        value += amplitude * ValueNoise(p);

        p *= 2.0;
        amplitude *= 0.5;
    }

    return value;
}

#endif