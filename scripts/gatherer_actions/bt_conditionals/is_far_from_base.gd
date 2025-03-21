extends BTConditional

func pre_tick(agent, blackboard: BTBlackboard):
	var actor: CharacterBody2D = agent
	var base: Area2D = blackboard.get_data("base");
	var proximity_dist: int = 32;#randi_range(4, 64);
	
	if base != null && actor.get_global_position().distance_to(base.global_position) > proximity_dist:
		set_true();
	else: set_false();

func post_tick(agent, blackboard, result): pass
