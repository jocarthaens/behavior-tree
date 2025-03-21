extends Area2D

var _set_free: bool = false;
var _type_name: String = "ore_resource";
var _ore_value: int = 1;

func _physics_process(delta: float) -> void:
	if _set_free == true:
		get_parent().remove_child(self);
		self.queue_free();

func collect_ore() -> int:
	_set_free = true;
	return _ore_value;

func get_type() -> String:
	return _type_name;
