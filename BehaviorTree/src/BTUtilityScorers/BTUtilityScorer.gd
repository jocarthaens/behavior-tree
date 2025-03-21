@icon("res://BehaviorTree/icons/btscorer.svg")
extends Node
class_name BTUtilityScorer

var bt_score: float: set = set_bt_score, get = get_bt_score

func set_bt_score(score: float):
	bt_score = score
func get_bt_score():
	return bt_score

func _update_score(blackboard: BTBlackboard) -> void: pass
