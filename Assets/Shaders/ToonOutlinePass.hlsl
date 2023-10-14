#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

struct Attributes
{
    float4 positionOS   : POSITION;
    float3 normalOS     : NORMAL;
    float4 tangentOS    : TANGENT;
    float2 uv           : TEXCOORD0;
};

struct Varyings
{
    float2 uv           : TEXCOORD0;
    float4 positionCS   : SV_POSITION;
};

float3 GetOutlinePosition(VertexPositionInputs vertexInput, VertexNormalInputs normalInput)
{
    float z = abs(vertexInput.positionVS.z);
    float width = _OutlineWidth * saturate(z) * 0.001;
    return vertexInput.positionWS + normalInput.normalWS * width;
}

Varyings OutlinePassVertex(Attributes input)
{
    VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS.xyz);
    VertexNormalInputs normalInput = GetVertexNormalInputs(input.normalOS, input.tangentOS);

    float3 positionWS = GetOutlinePosition(vertexInput, normalInput);

    Varyings output = (Varyings)0;
    output.uv = TRANSFORM_TEX(input.uv, _BaseMap);
    output.positionCS = TransformWorldToHClip(positionWS);

    return output;
}

half4 OutlinePassFragment(Varyings input) : SV_TARGET
{
    half4 lightMap = SAMPLE_TEXTURE2D(_LightMap, sampler_LightMap, input.uv);
    half material = lerp(lightMap.a, _CustomMaterialType, _UseCustomMaterialType);

    half4 color = _OutlineColor5;
    color = lerp(color, _OutlineColor4, step(0.2, material));
    color = lerp(color, _OutlineColor3, step(0.4, material));
    color = lerp(color, _OutlineColor2, step(0.6, material));
    color = lerp(color, _OutlineColor, step(0.8, material));

    return color;
}
