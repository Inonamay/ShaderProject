Shader "Unlit/TestShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", color) = (1,1,1,0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            struct VertexInput
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv0 : TEXCOORD0;
            };

            struct VertexOutput
            {
                float2 uv0 : TEXCOORD0;
                float3 normal : NORMAL;
                //UNITY_FOG_COORDS(1)
                float4 clipSpacePos : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            VertexOutput vert (VertexInput v)
            {
                VertexOutput o;
                o.clipSpacePos = UnityObjectToClipPos(v.vertex);
                o.normal = v.normal;
               // o.uv0 = TRANSFORM_TEX(v.uv0, _MainTex);s
                o.uv0 = v.uv0;
               // UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag(VertexOutput o) : SV_Target
            {
                float3 lightDir = _WorldSpaceLightPos0.xyz;
                float lightFalloff = dot(lightDir, o.normal);
                float3 lightColor = _LightColor0;
                float3 ambientLight = float3(0.1,0.1,0.1);

                return float4(_Color.rgb * lightFalloff * lightColor + ambientLight, 0);
            }
            ENDCG
        }
    }
}
