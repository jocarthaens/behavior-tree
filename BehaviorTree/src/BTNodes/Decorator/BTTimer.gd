@icon("res://BehaviorTree/icons/bttimer.svg")
extends BTDecorator
class_name BTTimer

@export var countdown_time: float = 0
@export_enum("TimeLimit", "Cooldown") var timer_mode: String
var _timer: Timer 

func tick(agent, blackboard):
	if _timer == null:
		_create_timer(agent)
	
	match timer_mode:
		"TimeLimit":
			if _timer.get_time_left() > 0:
				var response = bt_child._full_tick(agent, blackboard)
				return response
			elif _timer.get_time_left() == 0:
				_timer.queue_free()
				return Status.FAILURE
		"Cooldown":
			if _timer.get_time_left() > 0:
				return Status.FAILURE
			elif _timer.get_time_left() == 0:
				_timer.queue_free()
				var response = bt_child._full_tick(agent, blackboard)
				return response
		_:
			assert("Invalid mode: "+timer_mode)


func _create_timer(agent: Node):
	_timer = Timer.new()
	agent.add_child(_timer)
	_timer.one_shot = true
	_timer.autostart = false
	_timer.wait_time = countdown_time
	_timer.start()
