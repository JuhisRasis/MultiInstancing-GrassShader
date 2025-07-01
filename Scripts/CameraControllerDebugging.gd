extends Camera3D
@export var speed = 0.1
var sensitivity = .005
var rot_x = 0
var rot_y = 0

func _physics_process(delta):
	var direction = Vector3.ZERO
	if Input.is_action_pressed("move_right"):
		direction = get_transform().basis.x
	if Input.is_action_pressed("move_left"):
		direction = -get_transform().basis.x
	if Input.is_action_pressed("move_back"):
		direction = get_transform().basis.z
	if Input.is_action_pressed("move_forward"):
		direction = -get_transform().basis.z
	if Input.is_action_just_pressed("move_up"):
		direction.y += 1
	if Input.is_action_just_pressed("move_down"):
		direction.y -= 1
	if direction != Vector3.ZERO:
		direction = direction.normalized()
	position += Vector3(direction * speed)

func _input(event):
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("ms5Down"):
			rot_x += event.relative.x * sensitivity
			rot_y  += event.relative.y * sensitivity

			transform.basis = Basis() # reset rotation
			rotate_object_local(Vector3(0, 1, 0), -rot_x)
			rotate_object_local(Vector3(1, 0, 0), -rot_y)
