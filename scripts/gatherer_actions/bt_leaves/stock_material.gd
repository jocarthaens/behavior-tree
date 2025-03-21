extends BTLeaf

func tick(agent, blackboard):
	var stock: int = blackboard.get_data("material_stock");
	var max_stock: int = blackboard.get_data("max_material_stock");
	
	var action_label: Label = blackboard.get_data("action_label");
	action_label.text = name;
	
	if stock < max_stock:
		agent.collect();
		return Status.SUCCESS
	
	return Status.RUNNING;
