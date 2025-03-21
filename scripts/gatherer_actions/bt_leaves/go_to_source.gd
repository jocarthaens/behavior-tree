extends BTLeaf

func tick(agent, blackboard: BTBlackboard):
	var actor: CharacterBody2D = agent;
	var source: Area2D = blackboard.get_data("nearest_source");
	var proximity_dist: int = 10;
	var speed: int = 64;
	
	var action_label: Label = blackboard.get_data("action_label");
	action_label.text = name;
	
	if source == null:
		return Status.FAILURE;
	
	if actor.get_global_position().distance_to(source.global_position) < proximity_dist:
		actor.velocity = Vector2.ZERO;
		return Status.SUCCESS;
	
	actor.velocity = actor.global_position.direction_to(source.global_position) * speed;
	actor.move_and_slide();
	
	return Status.RUNNING;
