extends Area2D

var wood_stock: int = 4;
var max_wood_stock: int = 10;
var ore_stock: int = 6;
var max_ore_stock: int = 10;

var _wood_drop_timer: float = 0;
var _wood_drop_tick: float = 10.0;
var _ore_drop_timer: float = 0;
var _ore_drop_tick: float = 15.0;




func set_wood_stock(value: int):
	wood_stock = clampi(value, 0, max_wood_stock);

func get_wood_stock() -> int:
	return wood_stock;



func set_ore_stock(value: int):
	ore_stock = clampi(value, 0, max_ore_stock);

func get_ore_stock() -> int:
	return ore_stock;



func get_max_wood_stock() -> int:
	return max_wood_stock;

func get_max_ore_stock() -> int:
	return max_ore_stock;




func add_to_storage(type: String, value: int):
	match type:
		"wood_resource":
			wood_stock += value;
			#_wood_drop_timer = 0;
		"ore_resource":
			ore_stock += value;
			#_ore_drop_timer = 0;





func _physics_process(delta: float) -> void:
	_wood_drop_timer += delta;
	_ore_drop_timer += delta;
	if _wood_drop_timer >= _wood_drop_tick && wood_stock > 0:
		_wood_drop_timer = 0;
		wood_stock -= 1;
	if _ore_drop_timer >= _ore_drop_tick && ore_stock > 0:
		_ore_drop_timer = 0;
		ore_stock -= 1;
	
	%WoodBar.value = wood_stock;
	%WoodBar.max_value = max_wood_stock;
	%OreBar.value = ore_stock;
	%OreBar.max_value = max_ore_stock;


func get_type() -> String:
	return "stockpile"
