extends Node
var positionsArray = PackedVector3Array([])
var mMesh
var mMat
var mShaderMat
@export var shader : ShaderMaterial

func _ready() -> void:
	
	for i in get_tree().get_nodes_in_group("Interactable"): 
		positionsArray.push_back(i.global_position)
	print("a" + str(get_tree().get_nodes_in_group("Interactable")))
	
	pass

func _process(delta: float) -> void:
	var i2 = 0;
	for i in get_tree().get_nodes_in_group("Interactable"):
		positionsArray[i2] = i.global_position

		i2 += 1
	shader.set_shader_parameter("objectPositions", positionsArray)
	print(shader)
	pass
