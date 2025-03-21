extends BTLeaf

func tick(agent, blackboard):
	var actor: CharacterBody2D = agent
	var base: Area2D = blackboard.get_data("base");
	var proximity_dist: int = 32;#randi_range(4, 64);
	var speed: int = 64;
	
	var action_label: Label = blackboard.get_data("action_label");
	action_label.text = name;
	
	if base == null || actor.get_global_position().distance_to(base.global_position) < proximity_dist:
		actor.velocity = Vector2.ZERO;
		return Status.SUCCESS;
	
	actor.velocity = actor.global_position.direction_to(base.global_position) * speed;
	actor.move_and_slide();
	
	return Status.RUNNING;
