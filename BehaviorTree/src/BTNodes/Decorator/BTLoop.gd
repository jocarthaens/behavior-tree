@icon("res://BehaviorTree/icons/btloop.svg")
extends BTDecorator
class_name BTLoop

@export_range(1, 2_147_483_647) var loop_count: int = 1
@export var is_infinite: bool = false

var _current_loop_count = 0;

func tick(agent, blackboard):
	var response: Status = bt_child._full_tick(agent, blackboard)
	
	if response == Status.SUCCESS || Status.FAILURE:
		if _current_loop_count < loop_count || is_infinite == true:
			_current_loop_count += 1;
			response = Status.RUNNING;
		else:
			reset_loop()
	elif response == Status.SUSPENDED:
		reset_loop();
	
	return response

func reset_loop():
	_current_loop_count = 0;
