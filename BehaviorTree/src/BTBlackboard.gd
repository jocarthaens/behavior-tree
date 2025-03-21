@icon("res://BehaviorTree/icons/btblackboard.svg")
@tool
extends Node
class_name BTBlackboard

@onready var unique_name: StringName = name + "_" + str(self.get_instance_id())
var _blackboard: Dictionary = {}


func set_data(key, value) -> void:
	_blackboard[key] = value

func get_data(key) -> Variant:
	if has_data(key):
		return _blackboard[key]
	return null

func has_data(key) -> bool:
	return _blackboard.has(key)

func erase_data(key) -> Variant:
	var item = _blackboard.get(key)
	_blackboard.erase(key)
	return item
