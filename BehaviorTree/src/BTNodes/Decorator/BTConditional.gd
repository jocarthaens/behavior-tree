@icon("res://BehaviorTree/icons/btconditional.svg")
extends BTDecorator
class_name BTConditional

enum Condition {FALSE, TRUE}
@export var condition_mode: Condition = Condition.TRUE
var _is_condition_satisfied: bool = true

# Set conditions in either/both of these methods to achieve the BTConditional's full potential.
func pre_tick(agent, blackboard): pass
func post_tick(agent, blackboard, result): pass





func tick(agent, blackboard):
	if (
			(condition_mode == Condition.TRUE && _is_condition_satisfied == true)
			or (condition_mode == Condition.FALSE && _is_condition_satisfied == false)
	):
		return bt_child._full_tick(agent, blackboard)
	return Status.FAILURE

func set_true():
	_is_condition_satisfied = true

func set_false():
	_is_condition_satisfied = false
