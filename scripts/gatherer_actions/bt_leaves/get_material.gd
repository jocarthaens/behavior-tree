extends BTLeaf

func tick(agent, blackboard: BTBlackboard):
	var actor: CharacterBody2D = agent
	var material: Area2D = blackboard.get_data("nearest_material");
	var proximity_dist: int = 4;
	var speed: int = 48;
	
	var action_label: Label = blackboard.get_data("action_label");
	action_label.text = name;
	
	if material == null:
		return Status.FAILURE;
	
	if actor.get_global_position().distance_to(material.global_position) < proximity_dist:
		actor.velocity = Vector2.ZERO;
		actor.collect();
		return Status.SUCCESS;
	
	actor.velocity = actor.global_position.direction_to(material.global_position) * speed;
	actor.move_and_slide();
	
	return Status.RUNNING;
