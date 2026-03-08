shader_type spatial;
render_mode unshaded, depth_test_disabled;

#include "res://sdfShapes.gdshaderinc"
#include "res://sdfOperations.gdshaderinc"

group_uniforms RayMarchSettings;
uniform int MAX_STEPS = 100;
uniform float MAX_DIST = 100.0;
uniform float SURF_DIST = 0.01;
uniform vec3 color : source_color;

group_uniforms Shapes;
uniform vec3 positions[100];
uniform vec3 scales[100];


float GetDist(vec3 p){
	float dist = 1000.0;
	for(int i = 0; i < 100; i++){
		if(scales[i].x != 0.0){
			float sphere = sdSphere(p-positions[i],scales[i].x);
			dist = opSmoothUnion(sphere, dist,0.2);
		}
	}
	return dist;
}

vec3 GetNormal(vec3 p){
	float d = GetDist(p);
	vec2 e = vec2(0.0001,0.0);
	vec3 n = d - vec3(
		GetDist(p-e.xyy),
		GetDist(p-e.yxy),
		GetDist(p-e.yyx));
	return normalize(n);
}

float RayMarch(vec3 ro, vec3 rd){
	float d = 0.0;
	for(int i = 0; i < MAX_STEPS; i++){
		vec3 p = ro + rd*d;
		float dS = GetDist(p);
		d += dS;
		if(d > MAX_DIST || dS<SURF_DIST) break;
	}
	return d;
}

void fragment() {
	vec3 ws_pixel_pos = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	vec3 ro = CAMERA_POSITION_WORLD;
	vec3 rd = normalize(ws_pixel_pos-ro);
	
	float d = RayMarch(ro, rd);
	ALPHA = step(d, MAX_DIST);
	
	vec3 n = GetNormal(ro + rd*d);
    
	float shading = clamp(dot(n, vec3(1,1,0)),0,1);
	float shading2 = clamp(dot(n, vec3(0,1,-1)),0,1);	
	
	ALBEDO = color * (max(shading,shading2*0.1)+0.02);
}
