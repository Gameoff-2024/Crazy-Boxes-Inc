shader_type spatial;

uniform vec3 base : source_color = vec3(0.2, 0.5, 0.9);
uniform vec3 highlight1 : source_color = vec3(0.9, 0.5, 0.2);
uniform vec3 highlight2 : source_color = vec3(0.6, 1.0, 0.3);
uniform float noise_scale = 10.0;
uniform float roughness = 0.5;
uniform float shift_intensity = 1.0;

vec2 random(vec2 uv){
    uv = vec2( dot(uv, vec2(127.1,311.7) ),
               dot(uv, vec2(269.5,183.3) ) );
    return -1.0 + 2.0 * fract(sin(uv) * 43758.5453123);
}

float noise(vec2 uv) {
    vec2 uv_index = floor(uv);
    vec2 uv_fract = fract(uv);

    vec2 blur = smoothstep(0.0, 1.0, uv_fract);

    return mix( mix( dot( random(uv_index + vec2(0.0,0.0) ), uv_fract - vec2(0.0,0.0) ),
                     dot( random(uv_index + vec2(1.0,0.0) ), uv_fract - vec2(1.0,0.0) ), blur.x),
                mix( dot( random(uv_index + vec2(0.0,1.0) ), uv_fract - vec2(0.0,1.0) ),
                     dot( random(uv_index + vec2(1.0,1.0) ), uv_fract - vec2(1.0,1.0) ), blur.x), blur.y) + 0.5;
}

void fragment() {
	//Direction out of mesh along view angle
	vec3 V = normalize(-VIEW);
	//Quick convenient fresnel simulation
	float _fresnel = pow(1.0 - dot(NORMAL, V), 3.0);

	vec3 world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	float noise_value = noise(UV * noise_scale);

	float turbulence = abs(noise_value - 0.5) * 2.0;

	ALBEDO = mix(base, highlight1, noise_value);
	ALBEDO = mix(ALBEDO, highlight2, turbulence);

	float angle_factor = abs(dot(V, NORMAL));

	//Assumed to be mixing from black here
	ALBEDO = mix(ALBEDO, vec3(0.0), angle_factor * shift_intensity);

	//fade out according to roughness
	ALBEDO = mix(ALBEDO, vec3(0.0), _fresnel * roughness);

	SPECULAR = 1.0 - roughness;
}
