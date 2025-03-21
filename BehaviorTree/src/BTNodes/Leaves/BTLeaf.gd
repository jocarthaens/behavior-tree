@icon("res://BehaviorTree/icons/btleaf.svg")
extends BTNode
class_name BTLeaf

enum Utility{
	NONE, 
	CALCULATE
	}
@export_category("Utility Calculation")
@export var method: Utility = Utility.CALCULATE

@onready var bt_scorer: BTUtilityScorer

func _ready():
	get_utility_scorer()

func get_utility_scorer():
	if method == Utility.CALCULATE:
		for child in get_children():
			if child is BTUtilityScorer && bt_scorer == null:
				bt_scorer = child
				break



func _calculate_utility(agent, blackboard):
	if method == Utility.NONE:
		set_utility_score(0)
	elif method == Utility.CALCULATE:
		bt_scorer.update_scores(blackboard)
		var score = bt_scorer.get_bt_score()
		set_utility_score(score)
