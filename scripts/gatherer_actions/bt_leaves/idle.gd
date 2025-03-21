extends BTLeaf

func tick(agent, blackboard):
	var character: CharacterBody2D = agent;
	character.velocity = Vector2.ZERO;
	character.move_and_slide();
	
	var action_label: Label = blackboard.get_data("action_label");
	action_label.text = name;
	
	return Status.SUCCESS;
