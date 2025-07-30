extends Sprite3D

@onready var _camera: Camera3D = %Camera3D

func _process(delta: float) -> void:
	position.y = _camera.position.y
	look_at(_camera.position, Vector3.UP)
