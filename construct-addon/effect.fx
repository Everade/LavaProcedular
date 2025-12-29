#ifdef GL_FRAGMENT_PRECISION_HIGH
#define highmedp highp
#else
#define highmedp mediump
#endif

precision lowp float;

varying mediump vec2 vTex;
uniform mediump vec2 pixelSize;

// Builtin uniforms
uniform lowp sampler2D samplerFront;
uniform mediump vec2 srcStart;
uniform mediump vec2 srcEnd;
uniform mediump vec2 srcOriginStart;
uniform mediump vec2 srcOriginEnd;
uniform mediump vec2 layoutStart;
uniform mediump vec2 layoutEnd;
uniform mediump vec2 destStart;
uniform mediump vec2 destEnd;
uniform mediump float devicePixelRatio;
uniform mediump float layerScale;
uniform mediump float layerAngle;
uniform highmedp float seconds;
uniform mediump float zNear;
uniform mediump float zFar;

// Shader Parameters (Uniforms)
uniform float uniform_timeOffset;
uniform float uniform_timeSpeed;
uniform float uniform_uvScale;
uniform float uniform_noiseScale;
uniform float uniform_flowAngle;
uniform vec3 uniform_color;
uniform float uniform_contrast;


// Function dependencies
// Dependency code used by: Rotate Around Point
vec2 rotateAroundPoint(vec2 uv, vec2 center, float angle) {
    vec2 dir = uv - center;
    float s = sin(angle);
    float c = cos(angle);
    mat2 rot = mat2(c, -s, s, c);
    return rot * dir + center;
}

// Dependency code used by: flowNoise
    float hash(vec2 p) {
        p = fract(p * vec2(123.34, 456.21));
        p += dot(p, p + 45.32);
        return fract(p.x * p.y);
    }

    float valueNoise(vec2 p) {
        vec2 i = floor(p);
        vec2 f = fract(p);

        float a = hash(i);
        float b = hash(i + vec2(1.0, 0.0));
        float c = hash(i + vec2(0.0, 1.0));
        float d = hash(i + vec2(1.0, 1.0));

        vec2 u = f * f * (3.0 - 2.0 * f);

        return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
    }


void main() {
    // contrast
    float var_0 = uniform_contrast;

    // color
    vec3 var_1 = uniform_color;

    // noiseScale
    float var_2 = uniform_noiseScale;

    // uvScale
    float var_3 = uniform_uvScale;

    // flowAngle
    float var_4 = uniform_flowAngle;

    // timeSpeed
    float var_5 = uniform_timeSpeed;

    // seconds
    float var_6 = seconds;

    // timeOffset
    float var_7 = uniform_timeOffset;

    // Front UV
    vec2 var_8 = vTex;

    // srcStart
    vec2 var_9 = srcStart;

    // srcEnd
    vec2 var_10 = srcEnd;

    // layoutStart
    vec2 var_11 = layoutStart;

    // layoutEnd
    vec2 var_12 = layoutEnd;

    // Vec3
    vec3 var_13 = vec3(var_0, var_0, var_0);

    // Vec3 Decompose
    float var_14 = var_1.x;
    float var_15 = var_1.y;
    float var_16 = var_1.z;

    // To Radians
    float var_17 = radians(var_4);

    // Math
    float var_18 = var_6 + var_7;

    // Remap
    vec2 var_19 = var_11 + (var_8 - var_9) * (var_12 - var_11) / (var_10 - var_9);

    // Vec3
    vec3 var_20 = vec3(var_14, var_15, var_16);

    // Math
    float var_21 = var_18 * var_5;

    // Vec2 Decompose
    float var_22 = var_19.x;
    float var_23 = var_19.y;

    // Set Variable
    float temp_time = var_21;

    // Flip WebGPU
    float var_24 = var_23;

    // Get Variable
    float var_25 = temp_time;

    // Vec2
    vec2 var_26 = vec2(var_22, var_24);

    // Rotate Around Point
    vec2 var_27 = rotateAroundPoint(var_26, vec2(0.0, 0.0), var_17);

    // Multiply Vector
    vec2 var_28 = var_27 * var_3;

    // flowNoise
    vec2 p = var_28;
    float noiseScale = var_2;
    float time = var_25;

    float period = 32.0;
    float wrappedTime = mod(time, period);

    float z = 2.0;
    float rz = 0.0;
    vec2 bp = p;

    for (int i = 1; i < 7; i++) {
        p += wrappedTime * 0.6;
        bp += wrappedTime * 1.9;

        float ep = 0.09;

        vec2 uv1 = vec2(p.x + ep, p.y) * 0.01 + vec2(wrappedTime * 0.05, wrappedTime * 0.03);
        vec2 uv2 = vec2(p.x - ep, p.y) * 0.01 + vec2(wrappedTime * 0.05, wrappedTime * 0.03);
        vec2 uv3 = vec2(p.x, p.y + ep) * 0.01 + vec2(wrappedTime * 0.05, wrappedTime * 0.03);
        vec2 uv4 = vec2(p.x, p.y - ep) * 0.01 + vec2(wrappedTime * 0.05, wrappedTime * 0.03);

        float n1 = valueNoise(uv1 * noiseScale);
        float n2 = valueNoise(uv2 * noiseScale);
        float n3 = valueNoise(uv3 * noiseScale);
        float n4 = valueNoise(uv4 * noiseScale);

        vec2 gr = vec2(n1 - n2, n3 - n4);

        float angle = wrappedTime * 6.0 - (0.05 * p.x + 0.03 * p.y) * 40.0;
        float c = cos(angle);
        float s = sin(angle);

        gr = vec2(gr.x * c - gr.y * s, gr.x * s + gr.y * c);

        p += gr * 0.5;

        vec2 uv_rz = p * 0.01 + vec2(wrappedTime * 0.05, wrappedTime * 0.03);
        float n_rz = valueNoise(uv_rz * noiseScale);

        rz += (sin(n_rz * 7.0) * 0.5 + 0.5) / z;

        p = mix(bp, p, 0.77);

        z *= 1.4;
        p *= 2.0;
        bp *= 1.9;
    }

    float var_29 = rz;

    // Vec3
    vec3 var_30 = vec3(var_29, var_29, var_29);

    // Math
    vec3 var_31 = var_20 / var_30;

    // Power
    vec3 var_32 = pow(var_31, var_13);

    // Vec3 Decompose
    float var_33 = var_32.x;
    float var_34 = var_32.y;
    float var_35 = var_32.z;

    // Vec4
    vec4 var_36 = vec4(var_33, var_34, var_35, 1.0);

    // Output
    gl_FragColor = var_36;
}
