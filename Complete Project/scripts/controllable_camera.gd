extends Node3D
class_name ControllableCamera

@export_group("Parameters")
@export var distance: float = 4.0
@export var min_pitch: float = -90.0
@export var max_pitch: float = 75.0
@export var rotation_speed: float = 10.0
@export var sensitivity: float = 0.1

@onready var spring_arm: SpringArm3D = $GimbalH/GimbalV/SpringArm3D
@onready var gimbal_h: Node3D = $GimbalH
@onready var gimbal_v: Node3D = $GimbalH/GimbalV

var _rot_h: float = 0
var _rot_v: float = 0
var is_capturing_mouse: bool = true

func _ready() -> void:
	spring_arm.spring_length = distance 
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		is_capturing_mouse = !is_capturing_mouse
		
		if is_capturing_mouse:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if is_capturing_mouse and event is InputEventMouseMotion:
		_rot_h -= event.relative.x * sensitivity
		_rot_v -= event.relative.y * sensitivity
	
	_rot_v = clamp(_rot_v, min_pitch, max_pitch)

func _physics_process(delta: float) -> void:
	spring_arm.spring_length = lerpf(spring_arm.spring_length, distance, 10.0 * delta)
	
	gimbal_h.rotation_degrees.y = lerpf(gimbal_h.rotation_degrees.y, _rot_h, rotation_speed * delta)
	gimbal_v.rotation_degrees.x = lerpf(gimbal_v.rotation_degrees.x, _rot_v, rotation_speed * delta)
