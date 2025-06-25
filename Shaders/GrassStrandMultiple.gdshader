shader_type spatial;

//Higher wind direction values double as scaling
global uniform vec2 windDirection = vec2(2,1);	//ReadOnly
varying vec3 _windDirection;
//WindNoiseTexture to break symmetric sway movement
uniform sampler2D windNoiseTexture;
varying vec2 tex_position;
uniform float noiseScale = 0.5;
uniform float noiseTextureScrollSpeedMultiplier = .03;

//InteractableGrass
uniform float interaction_power = 1;
uniform float interaction_radius = 1.;
//Coloring
uniform float color_scale = 0.3;
uniform float color_grad_height = 0.5;
uniform vec4 top_color;
uniform vec4 bot_color;
varying vec3 vert;
render_mode cull_disabled;
//render_mode world_vertex_coords;

//Change amount of max interactable objects
//Change both values
uniform vec3 objectPositions[2]; 	//Read-Only 
varying vec3 _objectPositions[2];	//
void vertex() {

	vec3 world_vertex = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;

	for(int i = 0; i < 2; i++){
		_objectPositions[i] = objectPositions[i];
		//_objectPositions[0] = vec3(_objectPositions[0].x,_objectPositions[0].y,_objectPositions[0].z);
		vec3 direction_to_object = world_vertex - _objectPositions[i];
		direction_to_object.y = 0.0;
		direction_to_object = normalize(direction_to_object);
		float distance_to_object = distance(_objectPositions[i], world_vertex);
		float interaction_strength = smoothstep(.6, 0.0, distance_to_object * interaction_radius);
		direction_to_object = (vec4(direction_to_object, 1.0) * MODEL_MATRIX).xyz;
		VERTEX += direction_to_object * interaction_strength * interaction_power  * (4.0 - UV.y);
		VERTEX += direction_to_object * interaction_strength * VERTEX.y * (25.0- UV.y);
	}
	_windDirection = vec3(windDirection.x, 1, windDirection.y);
	//_windDirection = normalize(_windDirection);

	vec4 localPosition = vec4(VERTEX, 1.);
	vec4 worldPosition = MODEL_MATRIX * localPosition;
	vec4 viewPosition = VIEW_MATRIX * worldPosition;
	vec4 projectedPosition = PROJECTION_MATRIX * viewPosition; //either orthographic or perspective
	vec4 gl_Position = projectedPosition;
	
	tex_position = gl_Position.xz / 2.0 + 0.5;
	float height = texture(windNoiseTexture, tex_position + TIME * noiseTextureScrollSpeedMultiplier).x -0.5;
	//VERTEX = 1. + VERTEX.y * height * noiseScale;
	
	VERTEX = vec3(localPosition.x + sin(TIME)* _windDirection.x * localPosition.y, VERTEX.y, localPosition.z * _windDirection.y  * localPosition.y);
	VERTEX = vec3(VERTEX.x + VERTEX.y * height * noiseScale,VERTEX.y,VERTEX.z);

	// Transform the direction vector from world space back to model space
	vert = vec3(localPosition.x,localPosition.y,localPosition.z);
	
	//ROTATE FOLIAGE TOWARDS CAMERA
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);
	MODELVIEW_MATRIX = MODELVIEW_MATRIX * mat4(vec4(length(MODEL_MATRIX[0].xyz), 0.0, 0.0, 0.0), vec4(0.0, length(MODEL_MATRIX[1].xyz), 0.0, 0.0), vec4(0.0, 0.0, length(MODEL_MATRIX[2].xyz), 0.0), vec4(0.0, 0.0, 0.0, 1.0));
}

void fragment() {
	//ALBEDO = vec3(.3 *VERTEX.x,1,.3*VERTEX.z);
	ALBEDO = mix(bot_color,top_color,(vert.y+color_grad_height)*color_scale).xyz;
	//ALBEDO = vec3(0,1,0);
	NORMAL *= FRONT_FACING ? 1.0 : -1.0;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
