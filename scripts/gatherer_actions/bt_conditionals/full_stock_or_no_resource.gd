extends BTConditional

func pre_tick(agent, blackboard: BTBlackboard):
	var source_count: int = blackboard.get_data("source_count")
	var max_stock: int = blackboard.get_data("max_material_stock")
	var stock: int = blackboard.get_data("material_stock")
	var is_carrying: bool = blackboard.get_data("is_carrying_material")
	var material: Area2D = blackboard.get_data("nearest_material")
	
	if (source_count <= 0 || stock >= max_stock) && is_carrying == false && material == null: set_true()
	else: set_false()

func post_tick(agent, blackboard, result): pass
