extends BTConditional

func pre_tick(agent, blackboard: BTBlackboard):
	var tool_hp: int = blackboard.get_data("tool_hp");
	var source_count: int = blackboard.get_data("source_count");
	var stock: int = blackboard.get_data("material_stock");
	var max_stock: int = blackboard.get_data("max_material_stock");
	var is_carrying: bool = blackboard.get_data("is_carrying_material");
	var is_mining_source: bool = blackboard.get_data("is_mining_source");
	
	if tool_hp > 0 && source_count > 0 && stock < max_stock && is_carrying == false || is_mining_source == true: set_true();
	else: set_false();

func post_tick(agent, blackboard, result): pass
