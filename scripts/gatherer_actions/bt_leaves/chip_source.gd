extends BTLeaf

func tick(agent, blackboard: BTBlackboard):
	var actor: CharacterBody2D = agent;
	var source: Area2D = blackboard.get_data("nearest_source");
	var material: Area2D = blackboard.get_data("nearest_material");
	var is_mining: bool = blackboard.get_data("is_mining_source");
	var finished_anim: String = blackboard.get_data("finished_animation_name");
	var proximity_dist: int = 16;
	
	var action_label: Label = blackboard.get_data("action_label");
	action_label.text = name;
	
	if source == null || actor.get_global_position().distance_to(source.global_position) > proximity_dist:
		blackboard.set_data("is_mining_source", false);
		return Status.FAILURE;
	
	if material != null && finished_anim.begins_with("melee"):
		blackboard.set_data("is_mining_source", false);
		return Status.SUCCESS;
	
	blackboard.set_data("is_mining_source", true);
	
	return Status.RUNNING;
