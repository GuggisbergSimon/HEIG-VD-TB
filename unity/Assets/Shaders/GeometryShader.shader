Shader "Renderers/GeometryShader" {
    Properties {
        _Color1 ("Color1", Color) = (1,1,1,1)
        _Color2 ("Color2", Color) = (1,1,1,1)
        _ColorMap ("ColorMap", 2D) = "white" {}

        _AlphaCutoff ("Alpha Cutoff", Range(0.0, 1.0)) = 0.5
    }

    HLSLINCLUDE
    #pragma target 4.5
    #pragma only_renderers d3d11 playstation xboxone xboxseries vulkan metal switch
    #pragma multi_compile_instancing
    #pragma multi_compile _ _DOTS_INSTANCING_ON
    ENDHLSL

    SubShader {
        Pass {
            Name "FirstPass"
            Tags {
                "LightMode"="FirstPass"
            }

            Blend Off
            ZWrite Off
            ZTest LEqual

            HLSLPROGRAM
            #define _ALPHATEST_ON
            #define _ENABLE_FOG_ON_TRANSPARENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT

            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_TANGENT_TO_WORLD

            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/RenderPass/CustomPass/CustomPassRenderers.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/VertMesh.hlsl"

            TEXTURE2D(_ColorMap);
            float4 _ColorMap_ST;
            float4 _Color1;
            float4 _Color2;

            PackedVaryingsType Vert(AttributesMesh inputMesh)
            {
                VaryingsType varyingsType;
                varyingsType.vmesh = VertMesh(inputMesh);
                varyingsType.vmesh.positionCS = float4(inputMesh.positionOS, 1.0);
                return PackVaryingsType(varyingsType);
            }

            [maxvertexcount(3)]
            void Geometry(uint pid: SV_PrimitiveID, triangle PackedVaryingsType input[3], inout TriangleStream<PackedVaryingsType> outstream)
            {
                float offset = 1.0 + sin(_Time.y % 3.14);
                
                PackedVaryingsType p0 = input[0];
                PackedVaryingsType p1 = input[1];
                PackedVaryingsType p2 = input[2];

                float3 world_0 = TransformObjectToWorld(p0.vmesh.positionCS * offset);
                float3 world_1 = TransformObjectToWorld(p1.vmesh.positionCS * offset);
                float3 world_2 = TransformObjectToWorld(p2.vmesh.positionCS * offset);

                p0.vmesh.positionCS = mul(UNITY_MATRIX_VP, float4(world_0, 1.0));
                p1.vmesh.positionCS = mul(UNITY_MATRIX_VP, float4(world_1, 1.0));
                p2.vmesh.positionCS = mul(UNITY_MATRIX_VP, float4(world_2, 1.0));

                outstream.Append(p0);
                outstream.Append(p1);
                outstream.Append(p2);
            }

            float4 Frag(PackedVaryingsType packedInput) : SV_Target
            {
                float offset = 1.0 + sin(_Time.y % 3.14);
                float4 outColor = lerp(_Color1, _Color2, offset);
                return outColor;
            }

            #pragma vertex Vert
            #pragma geometry Geometry
            #pragma fragment Frag

            ENDHLSL
        }
    }
}