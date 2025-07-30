extends CharacterBody3D

@export_group("Camera")
@export_range(0.0,1.0) var mouse_sensivity := 0.10

@export_group("Movement")
@export var move_speed := 9.0
@export var acceleration := 20.0
@export var rotation_speed := 12.0

var _camera_input_direction := Vector2.ZERO # x,y only
#var _camera_up_down_factor := 0.7
var _last_movement_direction := Vector3.BACK
var _gravity := -30.0

@onready var _camera_pivot: Node3D = %CameraPivot
@onready var _camera: Camera3D = %Camera3D
@onready var player_visuals: Node3D = %PlayerVisuals

func _input(event: InputEvent) -> void: # _input(): Called for all input events, even if UI handles them.
	if event.is_action_pressed("ClickLeft"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
	if event.is_action_pressed("ESC"): # ESC
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _unhandled_input(event: InputEvent) -> void: # _unhandled_input(): Called only if no UI consumed the event.
	var is_camera_motion := (
		event is InputEventMouseMotion and
		 Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED)
	if is_camera_motion:
		_camera_input_direction = event.screen_relative * mouse_sensivity # get values from mouse movement base of the screen size

func _physics_process(delta: float) -> void:
	# -- Camera Movement
	#_camera_pivot.rotation.x += (_camera_input_direction.y * _camera_up_down_factor) * delta # _camera_pivot.rotation.x = up and down
	#_camera_pivot.rotation.x = clamp(_camera_pivot.rotation.x,-PI / 6.0, PI / 8.0) # -30 & 60 degrees  using PI , because godot usses radians -> 60° = 1.0472 = PI / 3.0
	_camera_pivot.rotation.y -= _camera_input_direction.x * delta # _camera_pivot.rotation.y  = left and right
	_camera_input_direction = Vector2.ZERO # reset _camera_input_direction values to stop small movements
	# -- Player Movement
	var raw_input := Input.get_vector("MoveA", "MoveD", "MoveW", "MoveS") # left,right,up,down
	var forward := _camera.global_basis.z # basis is direction "arrows x,y,z" that are orianted to note base of like rotation,etc..
	var right := _camera.global_basis.x
	
	var move_direction := forward * raw_input.y + right * raw_input.x
	move_direction.y = 0.0
	move_direction = move_direction.normalized()
	
	var y_velocity := velocity.y
	velocity.y = 0.0
	velocity = velocity.move_toward(move_direction * move_speed, acceleration * delta) # Move velocity toward (desired_direction * max_speed) with acceleration over time
	velocity.y = y_velocity + _gravity * delta
	move_and_slide()
	
	if move_direction.length() > 0.2:
		_last_movement_direction = move_direction
	var target_angle := Vector3.BACK.signed_angle_to(_last_movement_direction, Vector3.UP)
	player_visuals.global_rotation.y = lerp_angle(player_visuals.rotation.y, target_angle, rotation_speed * delta)
	
	var ground_speed := velocity.length()
	if ground_speed > 0.0:
		player_visuals.move()
	else:
		player_visuals.idle()
