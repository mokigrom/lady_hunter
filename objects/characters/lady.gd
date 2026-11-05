## Player character
class_name Lady
extends CharacterBody3D

const SPEED: float = 5.0
const JUMP_VELOCITY: float = 5.0
const HEIGHT: float = 1.69

@export var camera: Camera3D
@export var camera_follow_speed: float = 4.0
var is_camera_following: bool = true

@onready var camera_look_target = $camera_look_target
@onready var camera_position = $camera_look_target/camera_position

func _ready() -> void:
	camera.rotation = Vector3(-90, 0, 0)

func _process(delta: float) -> void:
	if is_camera_following:
		camera.rotation = camera_position.rotation + camera_look_target.rotation
		camera.position = camera.position.lerp(camera_position.global_position, camera_follow_speed * delta)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("lady_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("lady_left", "lady_right", "lady_up", "lady_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
