extends Sprite2D

func _ready() -> void:
	randomize();
	frame = randi_range(0, hframes * vframes - 1)
