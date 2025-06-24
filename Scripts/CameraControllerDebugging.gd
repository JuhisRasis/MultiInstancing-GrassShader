extends Camera3D

# How fast the player moves in meters per second.
@export var speed = 0.1
# The downward acceleration when in the air, in meters per second squared.
var target_velocity = Vector3.ZERO
var sensitivity = .005
var rot_x = 0
var rot_y = 0

func _physics_process(delta):
	var direction = Vector3.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if Input.is_action_just_pressed("move_up"):
		direction.y += 1
	if Input.is_action_just_pressed("move_down"):
		direction.y -= 1
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		#$Pivot.basis = Basis.looking_at(direction)

	position += Vector3(direction * speed)


func _input(event):
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("ms5Down"):
			rot_x += event.relative.x * sensitivity
			rot_y  += event.relative.y * sensitivity

			transform.basis = Basis() # reset rotation
			rotate_object_local(Vector3(0, 1, 0), -rot_x)
			rotate_object_local(Vector3(1, 0, 0), -rot_y)

	# check whether the right mouse button is down...

	# Moving the Character
	#velocity = target_veloscity
	#move_and_slide()
