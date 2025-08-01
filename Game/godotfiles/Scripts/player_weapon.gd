extends Node3D

@export var gun_turn_speed := 9

@onready var bullet_position: Marker3D = $Gun/BulletPosition
const BULLET = preload("res://Scenes/bullet.tscn")
var one = true

func get_nearest_enemy() -> Node3D:
	var enemies = get_tree().get_nodes_in_group("enemies")
	var closest: Node3D = null
	var min_distance = INF
	for enemy in enemies:
		if enemy is Node3D:
			var distance = global_transform.origin.distance_to(enemy.global_transform.origin)
			if distance < min_distance:
				min_distance = distance
				closest = enemy
	return closest # returns = target


func _process(delta):
	var target = get_nearest_enemy()
	if target != null:
		#look_at(target.global_transform.origin, Vector3.UP)
		var direction = (target.global_transform.origin - global_transform.origin).normalized() # global_transform.origin gives the 3D position of the object.
		rotation.y = lerp_angle(rotation.y, atan2(-direction.x, -direction.z), delta * gun_turn_speed)

func _unhandled_input(event: InputEvent) -> void: # _unhandled_input(): Called only if no UI consumed the event.
	if event.is_action_pressed("AttackSpace"):
		one = true
		if one:
			spawn_instance(bullet_position.global_transform.origin)
		#print(bullet_position.global_transform.origin)


func spawn_instance(gun_position: Vector3) -> void:
	var instance = BULLET.instantiate()
	var shoot_dir = -bullet_position.global_transform.basis.z.normalized()
	var target_position = gun_position + shoot_dir
	# Rotate the instance to face shoot_dir BEFORE adding to the tree
	instance.look_at_from_position(gun_position, target_position, Vector3.UP)
	get_tree().current_scene.add_child(instance)
	one = false
