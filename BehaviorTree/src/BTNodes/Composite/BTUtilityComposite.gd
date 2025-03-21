@icon("res://BehaviorTree/icons/btutilcomposite.svg")
extends BTComposite
class_name BTUtilityComposite

@export_enum("Max Score", "Min score") var utility_selection = "Max Score"
## Randomizes selection if multiple actions has max/min values satisfied and are equal. This is to ensure that all possible options are chosen even if their values are equal.
@export var randomize_if_equals: bool = false

@onready var bt_utility_children: Array[BTNode]
var has_evaluated_scores: bool = false

func evaluate_utility_scores():
	if bt_children.size() > 0:
		bt_utility_children.clear()
		bt_utility_children.append_array(bt_children)
		
		if randomize_if_equals == true:
			randomize()
			bt_utility_children.shuffle()
		
		if utility_selection == "Max Score":
			bt_utility_children.sort_custom(
				func(a: BTNode, b: BTNode): 
					return a.get_utility_score() > b.get_utility_score())
					
		elif utility_selection == "Min Score":
			bt_utility_children.sort_custom(
				func(a: BTNode, b: BTNode): 
					return a.get_utility_score() < b.get_utility_score())
		
		has_evaluated_scores = true


# Resets the currently_processed child index, and reactivates the sorting of child BTNodes by its utility scores.
func reset_index():
	current_child_index = 0
	has_evaluated_scores = false
