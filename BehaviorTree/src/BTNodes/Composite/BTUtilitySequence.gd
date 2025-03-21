@icon("res://BehaviorTree/icons/btutilsequence.svg")
extends BTUtilityComposite
class_name BTUtilitySequence

func tick(agent, blackboard):
	var response = Status.SUSPENDED
	if bt_children.size() > 0 and current_child_index < bt_children.size():
		
		if current_child_index <= 0 && has_evaluated_scores == false:
			evaluate_utility_scores()
		
		response = bt_children[current_child_index]._full_tick(agent, blackboard)
		match response:
			Status.RUNNING:
				pass
			Status.SUCCESS:
				current_child_index += 1
				response = Status.RUNNING
				if (current_child_index >= bt_children.size()):
					reset_index()
					response = Status.SUCCESS
			Status.FAILURE, Status.SUSPENDED: # Merge into 1?
				reset_index()
				response = Status.FAILURE
			_:
				reset_index()
				assert("Invalid State: "+response)
		return response
	
	reset_index()
	return response
