A custom implementation of behavior tree AI framework, with added implementation for Utility AI.

## Behavior Tree AI Components

__Behavior Tree Components__:
+ __BTRoot__ -> the topmost part of the behavior tree that is responsible for running the whole behavior tree. Executes the calculation of utility scores first before running the behavior tree, if utility mode is enabled. This node can only have 1 BTNode as a child, and this child node will be executed first, downwards to the tipmost BTLeaf nodes.
+ __BTBlackboard__ -> data structure that allows access and modification of properties that are stored in its dictionary
+ __BTNode__ -> base class for all other types of nodes in a behavior tree. Contains the main full_tick() method that runs differently on different BTNode tyoes, but will always return a status result (SUCCESS, FAILURE, RUNNING, SUSPENDED). Suspended status means that the full_tick() method of a BTNode is not executed.

__BTNode Categories__:
* __BTComposite__ -> contains multiple child nodes that will be executed sequentially before returning a result from their children, depending on the type of BTComposite. Also included a Utility AI implementation of BTComposite nodes for Utility Calculations.
* __BTDecorator__ -> decorator nodes manages or modifies their child node's result or tick execution. Can only contain 1 child node.
* __BTLeaf__ -> leaf nodes contain action logic that will be executed, and returns a result after performing its action. If utility calculation is selected, it calculates its score from its BTUtilityScorer child node (BTLeaves can only have 1 BTUtilityScorer as child), if present, otherwise it returns a score of 0.

__Types of BTComposites__:
* __BTSequence__ -> iterates through its children nodes until either one of them returned a failure status, where this node returns failure, or all of its children returns a success status, in which this node return a success status.
* __BTSelector__ -> iterates through its children nodes until one of them returns a success, in which this node will return a success status on its tick. However, if no child nodes will return a failure status, this node will return a failure status.
* __BTParallel__ -> regardless of the children nodes' returned status on their full_tick() method, it will always return a success status.
* __BTUtilityComposite__ -> base class for utility composite nodes such as __BTUtilitySequence__ and __BTUtilitySelector__. Before running each of their children's tick() method, this class will first evaluate the utility scores of each of their children nodes to sort them by either the highest or lowest score, depending on the selected option to start either at the highest or lowest score. After sorting, the child nodes will be executed sequentially, until the specified results satisfy the corresponding type of BTUtilityComposite (__Selector__ or __Sequence__ Policy).

__Types of BTDecorators__:
* __BTConditional__ -> implemented as a BTDecorator rather than BTLeaf, this decorator node checks if its conditions are satisfied before executing its child node's tick.
* __BTEnforcer__ -> returns an enforced result (Success or Failure), regardless if its child node has returned a failed or succeeded status after finishing its full_tick().
* __BTGate__ -> Locks its child node, preventing any sort of tick execution until the unlocking node has finished running its tick, which is a selected BTNode within the tree. It can also be locked by a selected locking node within the tree that had finished ticking.
* __BTInverter__ -> Inverts the result returned by its child node (Success becomes Failure, and vice versa).
* __BTLoop__ -> Executes the full_tick() method of its child node multiple times, up until the end of the loop. (Loop count increments if child node returns a Success or Failure state)
* __BTTimer__ -> Regardless on the chosen timer mode, this node ticks its timer to its finishing time before running its child node's full_tick() method.

__BTUtilityScorers__:
-> Only BTLeaves can use BTUtilityScorers to set their utility scores. Other BTNodes will depend on BTLeaves to calculate their utility scores. This scorer works similarly to Utility AI's scoring system where they either formulate their utility score from their sources, or combine the scores of its children utility scorers to create its own, depending on the type of scorer. This class also provides a method for obtaining and setting its utility score.

__BTScorer Types__:
* __BTAggregator__ -> extends from BTUtilityScorer, aggregates scores from its children of UTILScorers.
* __BTConsideration__ -> extends from BTUtilityScorer, formulates its consideration score from its source by either using a response curve or a custom response function.


## Demo
Included in this framework is a demo about goblins that gathers resources to fill their stockpile area to its max capacity by mining ores and chopping wood. After gathering, they bring these resources to their stockpile. If their tool is broken, they will go to the forge area to get a new one. If their stockpile is full, they would stand idle either in their camp, or if carrying a resource, near the stockpile until restocking is possible. Their current actions are displayed above them.
