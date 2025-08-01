extends CharacterBody3D

@export_group("Movement")
@export var move_speed := 9.0
@export var acceleration := 20.0
@export var rotation_speed := 1.0

@onready var enemy_visuals: Node3D = $EnemyVisuals

@export var gun_turn_speed := 9
func get_nearest_player() -> CharacterBody3D:
	var players = get_tree().get_nodes_in_group("players")
	var closest: CharacterBody3D = null
	var min_distance = INF
	for player in players:
		if player is CharacterBody3D:
			var distance = global_transform.origin.distance_to(player.global_transform.origin)
			if distance < min_distance:
				min_distance = distance
				closest = player
	return closest # returns = target


func _process(delta):
	var target = get_nearest_player()
	if target != null:
		#look_at(target.global_transform.origin, Vector3.UP)
		var direction = (target.global_transform.origin - global_transform.origin).normalized() # global_transform.origin gives the 3D position of the object.
		rotation.y = lerp_angle(rotation.y, atan2(-direction.x, -direction.z), delta * rotation_speed)
