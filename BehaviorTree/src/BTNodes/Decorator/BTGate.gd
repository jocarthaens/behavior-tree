@icon("res://BehaviorTree/icons/btgate.svg")
extends BTDecorator
class_name BTGate

@export var is_startup_lock: bool = false
@export var is_permanent_lock: bool = false
@export var lock_time: float = 0.05

@export var locker: NodePath
@export_enum("FAILURE", "SUCCESS", "EITHER") var lock_state = "FAILURE"
@export var unlocker: NodePath
@export_enum("FAILURE", "SUCCESS") var unlock_state = "FAILURE"

var _is_locked := false

@onready var unlocker_node: BTNode = get_node_or_null(unlocker)
@onready var locker_node: BTNode = get_node_or_null(locker)


func tick(agent, blackboard):
	if _is_locked:
		return Status.FAILURE
	return bt_child._full_tick(agent, blackboard)

func post_tick(_agent, _blackboard, _result):
	if locker_node == null:
		_check_lock(bt_child)



func _ready():
	if is_startup_lock:
		_lock()
	if locker_node != null:
		locker_node.connect("has_ticked", _on_locker_tick(locker_node.get_node_state()))

func _on_locker_tick(_state):
	_check_lock(locker_node)
	set_node_state(locker_node.get_node_state())

func _lock():
	_is_locked = true
	
	if debug_mode == true:
		print(name + " locked for " + str(lock_time) + " seconds")
	
	if is_permanent_lock == true:
		return
	elif unlocker_node != null:
		while _is_locked == true:
			var result = await unlocker_node.has_ticked
			if result == unlock_state:
				_is_locked = false
	elif unlocker_node == null:
		await get_tree().create_timer(lock_time, false).timeout
		_is_locked = false

func _check_lock(current_locker_node: BTNode):
	var locker_node_state = current_locker_node.getNodeState()
	if ((lock_state == "EITHER" && locker_node_state != Status.RUNNING)
	|| (lock_state == "SUCCESS" && locker_node_state == Status.SUCCESS)
	|| (lock_state == "FAILURE" && locker_node_state == Status.FAILURE)):
		_lock()
