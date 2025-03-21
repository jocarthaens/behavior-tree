@icon("res://BehaviorTree/icons/btdecorator.svg")
extends BTNode
class_name BTDecorator

var bt_child: BTNode = null

func _ready():
	_check_decorator_children()

func _process(delta):
	if bt_child == null:
		_unalive()

func _check_decorator_children():
	if get_child_count() != 1 || bt_child == null:
		var error: String = "BTDecorator should only have one BTNode child."
		push_error(error)
		assert(get_child_count() == 1, error)

func _update_child(child: BTNode, is_entering: bool):
	if is_entering:
		if bt_child == null:
			bt_child = child
		elif bt_child != null:
			push_error("BTNode child not added because BTDecorator already has one.")
	elif not is_entering:
		_unalive()

func _unalive():
	#print("BTDecorator frees itself because it bears no child.")
	get_parent().remove_child.call_deferred(self)
	queue_free()

func _calculate_utility(agent, blackboard):
	bt_child._calculate_utility(agent, blackboard)
	var value: float = bt_child.getUtilityScore()
	set_utility_score(value)
