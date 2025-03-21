@icon("res://BehaviorTree/icons/btnode.svg")
extends Node
class_name BTNode

@export var enable_node: bool = true 
@export var debug_mode: bool

signal has_ticked(state)

enum Status {FAILURE, SUCCESS, RUNNING, SUSPENDED}
var _node_state: Status: set = set_node_state, get = get_node_state
var _utility_score: float: set = set_utility_score, get = get_utility_score

var _parent


# Setters/Getters of BTNode's utility score (for Utility-based behavior trees)

func set_utility_score(score: float):
	_utility_score = score
func get_utility_score() -> float:
	return _utility_score



# Setters/Getters of BTNode's status

func set_node_state(state: Status):
	_node_state = state
func get_node_state() -> Status:
	return _node_state



# Stages of ticks
func pre_tick(_agent: Node, _blackboard: BTBlackboard) -> void: pass
func tick(_agent: Node, _blackboard: BTBlackboard) -> Status: return Status.SUCCESS
func post_tick(_agent: Node, _blackboard: BTBlackboard, _result: Status) -> void: pass




# Methods used to update its parent BTComposite/BTDecorator upon entering/exiting the scene tree

func _enter_tree():
	_parent = get_parent()
	if (_parent is BTComposite or _parent is BTDecorator):
		_parent._update_child(self, true)
func _exit_tree():
	if (_parent is BTComposite or _parent is BTDecorator):
		_parent._update_child(self, false)



# Calculates the utility score. This will be called first in the BTRoot's _run_behavior_tree() method,
# and it should call all the connected nodes' _calculate_utility() method
# towards the bottom of the tree, just like the full_tick() method.
func _calculate_utility(_agent: Node, _blackboard: BTBlackboard):
	set_utility_score(0)


# The full tick that will be called on every tick for the behavior tree to function.
func _full_tick(agent: Node, blackboard: BTBlackboard) -> Status:
	if not enable_node:
		set_node_state(Status.SUSPENDED)
		return Status.SUSPENDED
	
	if debug_mode == true:
		print(name)
	
	pre_tick(agent, blackboard)
	
	set_node_state(Status.RUNNING)
	var result: Status = tick(agent, blackboard)
	set_node_state(result)
	
	post_tick(agent, blackboard, result)
	emit_signal("has_ticked",result)
	
	return result
