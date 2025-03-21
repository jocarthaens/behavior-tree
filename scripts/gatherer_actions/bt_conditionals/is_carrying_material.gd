extends BTConditional

func pre_tick(agent, blackboard: BTBlackboard):
	var is_carrying: bool = blackboard.get_data("is_carrying_material")
	
	if is_carrying == true: set_true();
	else: set_false();

func post_tick(agent, blackboard, result): pass
