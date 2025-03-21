@icon("res://BehaviorTree/icons/btaggregator.svg")
extends BTUtilityScorer
class_name BTAggregator

enum CompoundMethod{
	AVERAGE, 
	MULTIPLICATION,
	MINIMUM,
	MAXIMUM,
	ADDITION,
	GEOMETRIC_MEAN,
	HARMONIC_MEAN
	}
@export var compound: CompoundMethod = CompoundMethod.AVERAGE
var _compounder: MATHCompounder = MATHCompounder.new()
var _scorer_list: Array[BTUtilityScorer]

var _is_initialized := false





# Methods that allow for adding and removing BTUtilityScorer instances, and also clearing the list of its BTUtilityScorer nodes.

func add_scorer(bt_scorer):
	if bt_scorer is BTUtilityScorer:
		_scorer_list.append(bt_scorer)
	elif bt_scorer is Array:
		for scorer in bt_scorer:
			if scorer is BTUtilityScorer:
				_scorer_list.append(scorer)
	elif not (bt_scorer is BTUtilityScorer) and not (bt_scorer is Array):
		push_warning("Input is neither a BTUtilityScorer instance nor contain any BTUtilityScorer instances.")
	
func remove_scorer(bt_scorer):
	if bt_scorer is BTUtilityScorer:
		_scorer_list.erase(bt_scorer)
	elif bt_scorer is Array:
		var scorer_array = bt_scorer.duplicate()
		for scorer in scorer_array:
			if scorer is BTUtilityScorer:
				_scorer_list.erase(scorer)
	elif not (bt_scorer is BTUtilityScorer)  and not (bt_scorer is Array):
		push_warning("Input is neither a BTUtilityScorer instance nor contain any matching BTUtilityScorer instances.")

func clear_scorer():
	_scorer_list.clear()







# Functions that initializes the UTILAggregator node after entering the scene tree.

func _ready():
	_initialize()

func _initialize():
	set_bt_score(0)
	_gather_scorers()
	_check_scorer_list()
	_is_initialized = true

func _gather_scorers():
	_scorer_list.clear()
	var scorer_children = get_children()
	add_scorer(scorer_children)

func _check_scorer_list():
	if _scorer_list.size() <= 0:
		push_error("BTAggregator doesn't have a list of BTScorer nodes.")
		assert(_scorer_list.size() > 0,"UTILAction doesn't have a list of BTScorer nodes.")






# Updates the scorers and combines their scores. Called upon by either parent UTILScorer or UTILAction nodes.
func _update_score(blackboard):
	if not _is_initialized:
		_initialize()
	for bt_scorer in _scorer_list:
		bt_scorer._update_scores(blackboard)
	_aggregate_scorers()

# Combines scores and set the result as the UTILAggregate's score.
func _aggregate_scorers():
	var bt_score_list: Array[float] = []
	for bt_scorer in _scorer_list:
		var value: float = bt_scorer.get_bt_score()
		bt_score_list.append(value)
	var score = _compounder.calculate(bt_score_list, compound)
	set_bt_score(score)
