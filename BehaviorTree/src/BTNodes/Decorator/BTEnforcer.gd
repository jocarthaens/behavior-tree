@icon("res://BehaviorTree/icons/btenforcer.svg")
extends BTDecorator
class_name BTEnforcer

enum Enforcer {FAILER, SUCCEEDER}
@export var forced_result_type: Enforcer

func tick(agent, blackboard):
	var response = bt_child._full_tick(agent, blackboard)
	if response != Status.SUSPENDED:
		if response == Status.RUNNING:
			return Status.RUNNING
		elif forced_result_type == Enforcer.FAILER:
			return Status.FAILURE
		elif forced_result_type == Enforcer.SUCCEEDER:
			return Status.SUCCESS
	return response
