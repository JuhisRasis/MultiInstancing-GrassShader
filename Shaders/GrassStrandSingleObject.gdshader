shader_type spatial;
uniform int a = 0;
global uniform vec2 swayDirection = vec2(2,1);
uniform vec2 pushAwayFromPos = vec2(0,0);
render_mode world_vertex_coords;
uniform float color_scale = 0.3;
uniform float color_grad_height = -0.5;
uniform vec4 top_color;
uniform vec4 bot_color;
varying vec3 vert;
render_mode cull_disabled;
varying vec3 player_position;
uniform float interaction_power = 9999999;
uniform float interaction_radius = 1.;
uniform vec3 objectPosition[2];
void vertex() {
	vert = VERTEX;
	// Called for every vertex the material is visible on.
	//VERTEX += vec3(swayDirection.x,0,swayDirection.y);
	player_position = vec3(swayDirection.x,0.,swayDirection.y);
	//VERTEX.x = pow(VERTEX.y,3) + VERTEX.x;
	//VERTEX.z = sqrt(VERTEX.y);
	//VERTEX = (MODELVIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;

	// Calculate direction vector from the player to the vertex, ignoring the vertical component
	vec3 world_vertex = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	for(int i = 0; i > 1; i++){

	}
	vec3 direction_to_player = world_vertex - player_position;
    direction_to_player.y = 0.0;
    direction_to_player = normalize(direction_to_player);
	float distance_to_player = distance(player_position, world_vertex);
	float interaction_strength = smoothstep(.6, 0.0, distance_to_player);
	// Transform the direction vector from world space back to model space
	direction_to_player = (vec4(direction_to_player, 1.0) * MODEL_MATRIX).xyz;

	VERTEX += direction_to_player * interaction_strength * interaction_power  * (4.0 - UV.y);


	VERTEX +=  direction_to_player * interaction_strength * VERTEX.y * (15.0- UV.y);

	//VERTEX = vec3(VERTEX.x + swayDirection.x * VERTEX.y,VERTEX.y,VERTEX.z);
	//if(VERTEX.y < 0.0)
		//VERTEX.y = 0.0;

	//VERTEX = vec3(VERTEX.x + sin(TIME)* swayDirection.x * VERTEX.y,VERTEX.y * 1.,VERTEX.z + sin(TIME)* swayDirection.y  * VERTEX.y);
	//VERTEX = vec3(VERTEX.x, VERTEX.y * abs(VERTEX.x * 100.) + VERTEX.y * abs(VERTEX.z * 100.), VERTEX.z);
	//VERTEX = vec3(VERTEX.x* abs(VERTEX.x * 5.), VERTEX.y, VERTEX.z* abs(VERTEX.z * 5.));
	//VERTEX = vec3(VERTEX.x, VERTEX.y, VERTEX.z);
	//vec4 wrld_vertex = MAIN_CAM_INV_VIEW_MATRIX * vec4(VERTEX, 1.0);
	//VERTEX = vec3((sqrt(VERTEX.x *VERTEX.x +0.1)) + 1., VERTEX.y*5., VERTEX.z);
	//POSITION = vec4(POSITION.x, POSITION.y, POSITION.z, POSITION.w);
    //NORMAL = normalize((MODELVIEW_MATRIX * vec4(NORMAL, 0.0)).xyz);
    //BINORMAL = normalize((MODELVIEW_MATRIX * vec4(BINORMAL, 0.0)).xyz);
    //TANGENT = normalize((MODELVIEW_MATRIX * vec4(TANGENT, 0.0)).xyz);
}

void fragment() {

	//ALBEDO = vec3(.3 *VERTEX.x,1,.3*VERTEX.z);
	ALBEDO = mix(bot_color,top_color,(vert.y+color_grad_height)*color_scale).xyz;
	NORMAL *= FRONT_FACING ? 1.0 : -1.0;
	//vec3 world_vertex = (MODEL_MATRIX * vec4(VERTEX,1.0)).xyz;
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
