extends BTLeaf

func tick(agent, blackboard):
	var actor: CharacterBody2D = agent
	var stockpile: Area2D = blackboard.get_data("stockpile");
	var proximity_dist: int = 8;
	var speed: int = 32;
	
	var action_label: Label = blackboard.get_data("action_label");
	action_label.text = name;
	
	if stockpile == null:
		return Status.FAILURE;
	
	if actor.get_global_position().distance_to(stockpile.global_position) < proximity_dist:
		actor.velocity = Vector2.ZERO;
		return Status.SUCCESS;
	
	actor.velocity = actor.global_position.direction_to(stockpile.global_position) * speed;
	actor.move_and_slide();
	
	return Status.RUNNING;
