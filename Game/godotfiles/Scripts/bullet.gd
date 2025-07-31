extends CharacterBody3D

@export var bullet_speed := 50.0
@export var bullet_range := 3.0

func _ready():
	var timer = Timer.new()
	timer.wait_time = bullet_range  # seconds
	timer.one_shot = true  # timer runs once, then stops
	timer.autostart = true # start automatically
	add_child(timer)       # add timer as child to current node
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))

func _on_timer_timeout():
	remove_bullet()

func _physics_process(_delta):
	var direction = -transform.basis.z.normalized()
	velocity = direction * bullet_speed
	move_and_slide()
	# Check for collisions
	var collision_count = get_slide_collision_count()
	for i in range(collision_count):
		var collision = get_slide_collision(i)
		if collision:
			remove_bullet()

func remove_bullet():
	queue_free()  # This destroys (frees) the current node instance
