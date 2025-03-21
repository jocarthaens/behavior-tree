extends BTLeaf

func tick(agent, blackboard: BTBlackboard):
	
	var action_label: Label = blackboard.get_data("action_label");
	action_label.text = name;
	
	agent.collect();
	return Status.SUCCESS
