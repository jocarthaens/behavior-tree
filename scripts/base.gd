extends Area2D


var wood_tree_count: int = 0;
var boulder_ore_count: int = 0;
var stockpile: Area2D = null;
var forge: Area2D = null;

func _ready() -> void:
	_scan_area();

func _physics_process(delta: float) -> void:
	_scan_area();

# scan for area of interests and characterbody of gatherer, update gatherer's data
func _scan_area():
	wood_tree_count = 0;
	boulder_ore_count = 0;
	
	var areas: Array[Area2D] = get_overlapping_areas();
	for area: Area2D in areas:
		if area.has_method("get_type"):
			var type: String = area.get_type();
			match type:
				"wood_tree":
					if area.has_method("has_wood") && area.has_wood() == true:
						wood_tree_count += 1;
				"boulder_ore":
					if area.has_method("has_ore") && area.has_ore() == true:
						boulder_ore_count += 1;
				"stockpile":
					if stockpile == null:
						stockpile = area;
				"forge":
					if forge == null:
						forge = area;
	
	var bodies: Array[Node2D] = get_overlapping_bodies();
	for body in bodies:
		if body.has_method("get_type"):
			var type: String = body.get_type();
			if type == "gatherer" && body.has_method("get_blackboard"):
				var bb: BTBlackboard = body.get_blackboard();
				var tool_type: String = bb.get_data("tool_type");
				match tool_type:
					"axe":
						bb.set_data("source_count", wood_tree_count)
						bb.set_data("material_stock", stockpile.get_wood_stock())
						bb.set_data("max_material_stock", stockpile.get_max_wood_stock())
					"pickaxe":
						bb.set_data("source_count", boulder_ore_count);
						bb.set_data("material_stock", stockpile.get_ore_stock())
						bb.set_data("max_material_stock", stockpile.get_max_ore_stock())
				bb.set_data("stockpile", stockpile);
				bb.set_data("forge", forge);
				bb.set_data("base", self);
