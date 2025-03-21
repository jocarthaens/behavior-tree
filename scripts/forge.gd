extends Area2D

func _process(delta: float) -> void:
	%Animation.play("melee_right", -1, 2.0)

func repair_tool(bb: BTBlackboard) -> bool:
	bb.set_data("tool_hp", bb.get_data("max_tool_hp"));
	return true;

func get_type() -> String:
	return "forge";
