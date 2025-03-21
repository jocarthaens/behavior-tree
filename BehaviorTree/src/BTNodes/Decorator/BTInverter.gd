@icon("res://BehaviorTree/icons/btinverter.svg")
extends BTDecorator
class_name BTInverter

func tick(agent, blackboard):
	var response = bt_child._full_tick(agent, blackboard)
	if response != Status.SUSPENDED:
		if response == Status.FAILURE:
			return Status.SUCCESS
		if response == Status.SUCCESS:
			return Status.FAILURE
		return Status.RUNNING
	return response
