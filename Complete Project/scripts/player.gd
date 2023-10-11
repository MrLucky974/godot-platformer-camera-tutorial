extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var camera: ControllableCamera
@export var camera_follow_speed: float = 8.0
@export var turn_speed: float = 10.0

@onready var character_mesh = $Mesh

var direction: Vector3 = Vector3.ZERO
var move_rotation: float = 0.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("strafe_left", "strafe_right", "forward", "backward")
	direction = Vector3(input_dir.x, 0, input_dir.y)
	move_rotation = lerp(move_rotation, deg_to_rad(camera._rot_h), camera_follow_speed * delta)
	direction = direction.rotated(Vector3.UP, move_rotation)
	if direction:
		character_mesh.rotation.y = lerp_angle(character_mesh.rotation.y, atan2(-direction.x, -direction.z), turn_speed * delta)
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
