extends Node
var positionsArray = PackedVector3Array([])
var mMesh
var mMat
var mShaderMat
@export var shader : ShaderMaterial

func _ready() -> void:
	
	for i in get_tree().get_nodes_in_group("Otus"): 
		positionsArray.push_back(i.global_position)
		#.ShaderMaterial.set_shader_parameter("objectPositions", self.position)
	print("a" + str(get_tree().get_nodes_in_group("Otus")))
	
	#.ShaderMaterial.set_shader_parameter("objectPositions", self.position)
	pass

func _process(delta: float) -> void:
	var i2 = 0;
	for i in get_tree().get_nodes_in_group("Otus"):
		positionsArray[i2] = i.global_position

		i2 += 1
	shader.set_shader_parameter("objectPositions", positionsArray)
	print(shader)
	pass
