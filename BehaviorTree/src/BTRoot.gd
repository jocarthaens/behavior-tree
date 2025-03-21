@icon("res://BehaviorTree/icons/btroot.svg")
extends Node
class_name BTRoot

@export var enable_tree: bool = true
@export_enum("Idle", "Physics") var sync_mode = "Physics"
@export var debug_mode: bool = false
@export var agent: NodePath
@export var blackboard_node: BTBlackboard

@export_group("Utility Behavior Tree")
@export var utility_mode: bool = false
##Adjusts the update frequency of utility calculations. Limits itself only to the game's current FPS.
@export_range(1, 2_147_483_647) var updates_per_second: int = 60 
var counter: float = 0

@onready var agent_node: Node = get_node(agent) if agent != null else get_parent()
#@onready var blackboard_node: Node = get_node(blackboard_path) if blackboard_path != null else BTBlackboard.new()
@onready var bt_start_node: BTNode

##Overridable method for updating the blackboard per tick
func blackboard_update(blackboard: BTBlackboard): pass

func enable(): enable_tree = true
func disable(): enable_tree = false


func _ready():
	_initialize()
	
func _physics_process(delta):
	if not enable_tree:
		set_physics_process(false)
		return
	_run_behavior_tree(delta)

func _process(delta):
	if not enable_tree:
		set_process(false)
		return
	_run_behavior_tree(delta)




func _run_behavior_tree(delta):
	if debug_mode == true:
		print()
	
	blackboard_node.set_data("delta", delta)
	blackboard_update(blackboard_node)
	
	counter += delta
	if utility_mode == true && counter >= float(1.0/updates_per_second):
		bt_start_node._calculate_utility(agent_node, blackboard_node)
		counter = 0
	
	bt_start_node._full_tick(agent_node, blackboard_node)




func _initialize():
	_get_bt_node_child()
	if bt_start_node != null:
		_activate_tree()

func _get_bt_node_child():
	for child in self.get_children():
		if child is BTNode && bt_start_node == null:
			bt_start_node = child
			break
	_check_children()

func _check_children():
	if get_child_count() != 1:
		disable()
		var error: String = "Behavior Tree error: BTRoot should only have one BTNode child to function."
		push_error(error)
		assert(get_child_count() == 1,error)
	if bt_start_node == null:
		disable()
		var error: String = "Behavior Tree error: BTStartNode hasn't been set."
		push_error(error)
		assert(bt_start_node != null, error)

func _activate_tree():
	if enable_tree == false:
		return
	match sync_mode:
		"Idle":
			set_process(true)
			set_physics_process(false)
		"Physics":
			set_process(false)
			set_physics_process(true)
