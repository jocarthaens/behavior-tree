@icon("res://BehaviorTree/icons/btparallel.svg")
extends BTComposite
class_name BTParallel

# to be modified soon

func tick(agent, blackboard):
	if bt_children.size() > 0:
		for child in bt_children:
			current_child_index += 1
			child._full_tick(agent, blackboard)
		reset_index()
		return Status.SUCCESS
	return Status.SUSPENDED
