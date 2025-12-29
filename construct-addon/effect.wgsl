%%FRAGMENTINPUT_STRUCT%%
%%FRAGMENTOUTPUT_STRUCT%%

%%C3_UTILITY_FUNCTIONS%%

%%C3PARAMS_STRUCT%%

%%SAMPLERFRONT_BINDING%% var samplerFront : sampler;
%%TEXTUREFRONT_BINDING%% var textureFront : texture_2d<f32>;
// Shader Parameters (Uniforms)
struct ShaderParams {
	uniform_timeOffset : f32,
	uniform_timeSpeed : f32,
	uniform_uvScale : f32,
	uniform_noiseScale : f32,
	uniform_flowAngle : f32,
	uniform_color : vec3<f32>,
	uniform_contrast : f32,
};
%%SHADERPARAMS_BINDING%% var<uniform> shaderParams : ShaderParams;


// Function dependencies
// Dependency code used by: Rotate Around Point
fn rotateAroundPoint(uv: vec2<f32>, center: vec2<f32>, angle: f32) -> vec2<f32> {
    let dir = uv - center;
    let s = sin(angle);
    let c = cos(angle);
    let rot = mat2x2<f32>(c, -s, s, c);
    return rot * dir + center;
}

// Dependency code used by: flowNoise
    fn hash(p: vec2<f32>) -> f32 {
        var pp = fract(p * vec2<f32>(123.34, 456.21));
        pp += dot(pp, pp + vec2<f32>(45.32, 45.32));
        return fract(pp.x * pp.y);
    }

    fn valueNoise(p: vec2<f32>) -> f32 {
        let i = floor(p);
        let f = fract(p);

        let a = hash(i);
        let b = hash(i + vec2<f32>(1.0, 0.0));
        let c = hash(i + vec2<f32>(0.0, 1.0));
        let d = hash(i + vec2<f32>(1.0, 1.0));

        let u = f * f * (3.0 - 2.0 * f);

        return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
    }


@fragment
fn main(input : FragmentInput) -> FragmentOutput {
    var output : FragmentOutput;
    // contrast
    var var_0: f32 = shaderParams.uniform_contrast;

    // color
    var var_1: vec3<f32> = shaderParams.uniform_color;

    // noiseScale
    var var_2: f32 = shaderParams.uniform_noiseScale;

    // uvScale
    var var_3: f32 = shaderParams.uniform_uvScale;

    // flowAngle
    var var_4: f32 = shaderParams.uniform_flowAngle;

    // timeSpeed
    var var_5: f32 = shaderParams.uniform_timeSpeed;

    // seconds
    var var_6: f32 = c3Params.seconds;

    // timeOffset
    var var_7: f32 = shaderParams.uniform_timeOffset;

    // Front UV
    var var_8: vec2<f32> = input.fragUV;

    // srcStart
    var var_9: vec2<f32> = c3Params.srcStart;

    // srcEnd
    var var_10: vec2<f32> = c3Params.srcEnd;

    // layoutStart
    var var_11: vec2<f32> = c3Params.layoutStart;

    // layoutEnd
    var var_12: vec2<f32> = c3Params.layoutEnd;

    // Vec3
    var var_13: vec3<f32> = vec3<f32>(var_0, var_0, var_0);

    // Vec3 Decompose
    var var_14: f32 = var_1.x;
    var var_15: f32 = var_1.y;
    var var_16: f32 = var_1.z;

    // To Radians
    var var_17: f32 = radians(var_4);

    // Math
    var var_18: f32 = var_6 + var_7;

    // Remap
    var var_19: vec2<f32> = var_11 + (var_8 - var_9) * (var_12 - var_11) / (var_10 - var_9);

    // Vec3
    var var_20: vec3<f32> = vec3<f32>(var_14, var_15, var_16);

    // Math
    var var_21: f32 = var_18 * var_5;

    // Vec2 Decompose
    var var_22: f32 = var_19.x;
    var var_23: f32 = var_19.y;

    // Set Variable
    var temp_time: f32 = var_21;

    // Flip WebGPU
    var var_24 = -1.0 - var_23;

    // Get Variable
    var var_25: f32 = temp_time;

    // Vec2
    var var_26: vec2<f32> = vec2<f32>(var_22, var_24);

    // Rotate Around Point
    var var_27: vec2<f32> = rotateAroundPoint(var_26, vec2<f32>(0.0, 0.0), var_17);

    // Multiply Vector
    var var_28: vec2<f32> = var_27 * var_3;

    // flowNoise
    var p = var_28;
    let noiseScale = var_2;
    let time = var_25;

    let period = 32.0;
    let wrappedTime = time % period;

    var z = 2.0;
    var rz = 0.0;
    var bp = p;

    for (var i: i32 = 1; i < 7; i = i + 1) {
        p += wrappedTime * 0.6;
        bp += wrappedTime * 1.9;

        let ep = 0.09;

        let uv1 = vec2<f32>(p.x + ep, p.y) * 0.01 + vec2<f32>(wrappedTime * 0.05, wrappedTime * 0.03);
        let uv2 = vec2<f32>(p.x - ep, p.y) * 0.01 + vec2<f32>(wrappedTime * 0.05, wrappedTime * 0.03);
        let uv3 = vec2<f32>(p.x, p.y + ep) * 0.01 + vec2<f32>(wrappedTime * 0.05, wrappedTime * 0.03);
        let uv4 = vec2<f32>(p.x, p.y - ep) * 0.01 + vec2<f32>(wrappedTime * 0.05, wrappedTime * 0.03);

        let n1 = valueNoise(uv1 * noiseScale);
        let n2 = valueNoise(uv2 * noiseScale);
        let n3 = valueNoise(uv3 * noiseScale);
        let n4 = valueNoise(uv4 * noiseScale);

        var gr = vec2<f32>(n1 - n2, n3 - n4);

        let angle = wrappedTime * 6.0 - (0.05 * p.x + 0.03 * p.y) * 40.0;
        let c = cos(angle);
        let s = sin(angle);

        gr = vec2<f32>(gr.x * c - gr.y * s, gr.x * s + gr.y * c);

        p += gr * 0.5;

        let uv_rz = p * 0.01 + vec2<f32>(wrappedTime * 0.05, wrappedTime * 0.03);
        let n_rz = valueNoise(uv_rz * noiseScale);

        rz += (sin(n_rz * 7.0) * 0.5 + 0.5) / z;

        p = mix(bp, p, 0.77);

        z *= 1.4;
        p *= 2.0;
        bp *= 1.9;
    }

let var_29 = rz;

    // Vec3
    var var_30: vec3<f32> = vec3<f32>(var_29, var_29, var_29);

    // Math
    var var_31: vec3<f32> = var_20 / var_30;

    // Power
    var var_32: vec3<f32> = pow(var_31, var_13);

    // Vec3 Decompose
    var var_33: f32 = var_32.x;
    var var_34: f32 = var_32.y;
    var var_35: f32 = var_32.z;

    // Vec4
    var var_36: vec4<f32> = vec4<f32>(var_33, var_34, var_35, 1.0);

    // Output
    output.color = var_36;
    return output;
}
