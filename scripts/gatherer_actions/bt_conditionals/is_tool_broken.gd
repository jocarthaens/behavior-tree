extends BTConditional

func pre_tick(agent, blackboard: BTBlackboard):
	var tool_health: int = blackboard.get_data("tool_hp")
	var is_carrying: bool = blackboard.get_data("is_carrying_material")
	var material: Area2D = blackboard.get_data("nearest_material")
	
	if tool_health <= 0 && is_carrying == false && material == null: set_true();
	else: set_false();

func post_tick(agent, blackboard, result): pass
