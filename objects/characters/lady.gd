## Player character
class_name Lady
extends CharacterBody3D

const HEIGHT: float = 1.69

@export var speed: float = 6.0
@export var jump_velocity: float = 6.0
@export var friction: float = 28.0
@export var acceleration: float = 28.0

@export var camera: Camera3D
@export var camera_follow_speed: float = 5.0
@export var camera_distance: float = 10.634

var is_camera_following: bool = true

@onready var camera_look_target: Marker3D = $camera_look_target
@onready var camera_position: Marker3D = $camera_look_target/camera_position

func _ready() -> void:
	camera_look_target.position.y = 0

func _process(delta: float) -> void:
	if is_camera_following:
		camera.rotation = camera_position.rotation + camera_look_target.rotation
		camera.position = camera.position.lerp(camera_position.global_position, camera_follow_speed * delta)

func _physics_process(delta: float) -> void:
	if is_on_floor():
		_move_on_floor(delta)
		
		if Input.is_action_pressed("lady_jump"):
			velocity.y += jump_velocity
	else:
		velocity += get_gravity() * delta
	
	move_and_slide()

func _move_on_floor(delta: float) -> void:
	var input := Input.get_vector("lady_left", "lady_right", "lady_up", "lady_down")
	var direction := Vector3(input.x, 0.0, input.y)
	
	var movement_vector := Vector2(velocity.x, velocity.z)
	var target := Vector2(direction.x, direction.z) * speed
	
	var rate: float = acceleration if input == Vector2.ZERO else friction
	movement_vector = movement_vector.move_toward(target, rate * delta)
	
	velocity.x = movement_vector.x
	velocity.z = movement_vector.y
	
	
