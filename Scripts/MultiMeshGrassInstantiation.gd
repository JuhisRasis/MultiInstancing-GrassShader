extends MultiMeshInstance3D
@export var terrain : Node3D
@export var shader : ShaderMaterial
@export var ObjectToBeInstantiated : Mesh

var windSwayScale = 0.5
var meshVertAmount
var meshFaces
var globalPos
var multimesh_instance = MultiMeshInstance3D.new()
var t = 0
var terrainMesh : Mesh
var meshSize = 28
var positionsArray = PackedVector3Array([])

func _ready():
	for i in get_tree().get_nodes_in_group("Interactable"): 
		positionsArray.push_back(i.global_position)
	terrainMesh = terrain.get_child(0).get_mesh()
	
	if(terrainMesh!= null && terrain!= null && ObjectToBeInstantiated != null):
		multimesh = MultiMesh.new()
		multimesh.transform_format = MultiMesh.TRANSFORM_3D
		multimesh.mesh = ObjectToBeInstantiated
		meshFaces = ObjectToBeInstantiated.get_faces()
		
		#Debuggin: vertex amount
		
		#var mdtFoliage = MeshDataTool.new() 
		#var m2 = ObjectToBeInstantiated
		#mdtFoliage.create_from_surface(m2, 0)
		#meshVertAmount = mdtFoliage.get_vertex_count()
		#print("Amount of vertexes in foliage mesh: " + str(meshVertAmount))
		
		var mdt = MeshDataTool.new() 
		var m = terrainMesh
		mdt.create_from_surface(m, 0)
		var vertexAmount = mdt.get_vertex_count()
		multimesh.instance_count = vertexAmount
		print("Amount of vertexes in instantiated foliage: " + str(vertexAmount))

		#multimesh.visible_instance_count = multimesh.instance_count

		if(multimesh.mesh != null):
			for i in multimesh.instance_count:
				multimesh.set_instance_transform(i, Transform3D(Basis() / meshSize, mdt.get_vertex(i)))
		else:
			print(multimesh.mesh)

func _process(delta: float):
	t += 0.01
	RenderingServer.global_shader_parameter_set("windDirection", Vector2(sin(t* windSwayScale)* windSwayScale, sin(t* windSwayScale)* windSwayScale))
	var i2 = 0;
	for i in get_tree().get_nodes_in_group("Interactable"):
		positionsArray[i2] = i.global_position
		i2 += 1
	shader.set_shader_parameter("objectPositions", positionsArray)

	pass
