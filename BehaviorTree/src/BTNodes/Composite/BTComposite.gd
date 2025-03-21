@icon("res://BehaviorTree/icons/btcomposite.svg")
extends BTNode
class_name BTComposite

enum Utility{
	NONE, 
	CALCULATE, 
	INHERIT
	}
@export_category("Utility Calculation")
@export var method: Utility = Utility.CALCULATE
@export_enum("Max","Min") var selection = "Max"

@onready var bt_children: Array[BTNode]
var current_child_index: int = 0;

var bt_scorer: BTUtilityScorer = null


# Methods used for checking bt_children count and getting the utility scorer.

func _ready():
	_check_composite_children()
	_get_utility_scorer()

func _check_composite_children():
	if bt_children.size() <= 1:
		var error: String = "BTComposite should have more than one BTNode child."
		push_error(error)
		assert(bt_children.size() >= 1, error)
func _get_utility_scorer():
	if method == Utility.CALCULATE:
		for child in get_children():
			if child is BTUtilityScorer && bt_scorer == null:
				bt_scorer = child
				break



# Method called by its BTNode children. Updates the list of bt_children.
func _update_child(child: BTNode, is_entering: bool):
	if is_entering:
		bt_children.append(child)
	elif not is_entering:
		bt_children.erase(child)


# Calculates the utility score of itself and its children BTNodes.
# Responsible for calling all _calculate_utility() method 
# of BTNodes towards the bottom of the tree.
func _calculate_utility(agent, blackboard):
	if get_node_state() == Status.SUSPENDED:
		return
	
	if method == Utility.NONE || bt_scorer == null:
		set_utility_score(0)
	elif method == Utility.CALCULATE:
		bt_scorer.update_scores(blackboard)
		var score = bt_scorer.get_bt_score()
		set_utility_score(score)
	
	for bt_child in bt_children:
		bt_child._calculate_utility(agent, blackboard)
		
	if method == Utility.INHERIT:
		var best_score: float
		for bt_child: BTNode in bt_children:
			var value = bt_child.get_utility_score()
			if selection == "Max":
				best_score = max(best_score, value)
			elif selection == "Min":
				best_score = min(best_score, value)
		set_utility_score(best_score)


# Resets the currently_processed child index
func reset_index():
	current_child_index = 0

func currently_processed_index() -> int:
	return current_child_index
