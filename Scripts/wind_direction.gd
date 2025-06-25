extends Node3D
var vec2XZ : Vector2
func _process(delta: float):
	var axis = Vector3(0, 1, 0) # Or Vector3.RIGHT
	var rotation_amount = 0.01
	# Rotate the transform around the X axis by 0.1 radians.
	transform.basis = Basis(axis, rotation_amount) * transform.basis
	#vec2XZ = Vector2(.1, .2)
	#RenderingServer.global_shader_parameter_set("windDirection", vec2XZ)
	pass
