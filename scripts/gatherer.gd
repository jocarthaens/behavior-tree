#@tool
extends CharacterBody2D

enum Gatherer {Logger, Miner}

@export var gatherer_type: Gatherer = Gatherer.Logger: set = set_gatherer_type;
@onready var bb: BTBlackboard = get_node("BTBoard");

var _collect_timer: float = 0;
var _collect_duration: float = 0.16;

func set_gatherer_type(value: Gatherer):
	match value:
		Gatherer.Logger:
			%ToolSprite.frame = 1;
			%Resource.frame = 1;
		Gatherer.Miner:
			%ToolSprite.frame = 0;
			%Resource.frame = 0;
	gatherer_type = value;
	match value:
		Gatherer.Logger:
			%BTBoard.set_data("tool_type", "axe"); # axe, pickaxe
			%BTBoard.set_data("source_type", "wood_tree"); # boulder_ore, wood_tree
			%BTBoard.set_data("material_type", "wood_resource"); # wood_resource, ore_resource
		Gatherer.Miner:
			%BTBoard.set_data("tool_type", "pickaxe"); # axe, pickaxe
			%BTBoard.set_data("source_type", "boulder_ore"); # boulder_ore, wood_tree
			%BTBoard.set_data("material_type", "ore_resource"); # wood_resource, ore_resource


func get_blackboard() -> BTBlackboard:
	return bb;

func _ready() -> void:
	pass
	match gatherer_type:
		Gatherer.Logger:
			bb.set_data("tool_type", "axe"); # axe, pickaxe
			bb.set_data("source_type", "wood_tree"); # boulder_ore, wood_tree
			bb.set_data("material_type", "wood_resource"); # wood_resource, ore_resource
		Gatherer.Miner:
			bb.set_data("tool_type", "pickaxe"); # axe, pickaxe
			bb.set_data("source_type", "boulder_ore"); # boulder_ore, wood_tree
			bb.set_data("material_type", "ore_resource"); # wood_resource, ore_resource
	_initialize_blackboard();


func _initialize_blackboard():
	#bb.set_data("tool_type", "axe"); # axe, pickaxe
	bb.set_data("tool_hp", 3);
	bb.set_data("max_tool_hp", 3);
	
	#bb.set_data("source_type", ""); # boulder_ore, wood_tree
	bb.set_data("nearest_source", null);
	bb.set_data("source_count", 0); # to be filled by base?
	bb.set_data("is_mining_source", false);
	
	#bb.set_data("material_type", ""); # wood_resource, ore_resource
	bb.set_data("nearest_material", null);
	bb.set_data("is_carrying_material", false);
	bb.set_data("material_value", 0);
	
	bb.set_data("base", null);
	bb.set_data("forge", null);
	bb.set_data("stockpile", null);
	
	bb.set_data("material_stock", 0);
	bb.set_data("max_material_stock", 0);
	
	bb.set_data("face_direction", "right"); # right or left
	bb.set_data("finished_animation_name", "");
	
	bb.set_data("action_label", %ActionLabel);





func _physics_process(delta: float) -> void:
	pass
	_scan_area();
	
	if velocity.length() > 0:
		if velocity.x > 0:
			bb.set_data("face_direction", "right");
		elif velocity.x < 0:
			bb.set_data("face_direction", "left");
	
	if %CollectorShape.disabled == false:
		_collect_timer += delta;
		if _collect_timer >= _collect_duration:
			_collect_timer = 0;
			%CollectorShape.disabled = true;
	
	_animation();





func _scan_area():
	bb.set_data("nearest_source", null);
	bb.set_data("nearest_material", null);
	
	var areas: Array[Area2D] = %Sensor.get_overlapping_areas();
	for area: Area2D in areas:
		if area.has_method("get_type"):
			var type: String = area.get_type();
			match type:
				"boulder_ore", "wood_tree":
					var source_type: String = bb.get_data("source_type");
					if source_type == type:
						var other: Area2D = bb.get_data("nearest_source");
						if (other == null || self.global_position.distance_to(area.global_position) 
								< self.global_position.distance_to(other.global_position) ):
							bb.set_data("nearest_source", area);
				"wood_resource", "ore_resource":
					var material_type: String = bb.get_data("material_type");
					if material_type == type:
						var other: Area2D = bb.get_data("nearest_material");
						if (other == null || self.global_position.distance_to(area.global_position) 
								< self.global_position.distance_to(other.global_position) ):
							bb.set_data("nearest_material", area);
				"base":
					if bb.get_data("base") == null:
						bb.set_data("base", area);
				"forge":
					if bb.get_data("forge") == null:
						bb.set_data("forge", area);
				"stockpile":
					if bb.get_data("stockpile") == null:
						bb.set_data("stockpile", area);





func _animation():
	var face_direction: String = bb.get_data("face_direction");
	var is_carrying: bool = bb.get_data("is_carrying_material");
	var is_mining: bool = bb.get_data("is_mining_source")
	var tool_hp: int = bb.get_data("tool_hp");
	var current_anim: String = %Animator.current_animation;
	
	if is_mining == false:
		%Tool.visible = true if (tool_hp > 0 && is_carrying == false) else false;
		%Resource.visible = true if is_carrying == true else false;
			
		if velocity.length() > 0:
			if is_carrying == true:
				%Animator.play("carry_"+face_direction);
			else:
				%Animator.play("walk_"+face_direction);
		else:
			%Animator.play("idle_"+face_direction);
	else:
		%Animator.play("melee_"+face_direction);
	
	%ToolHPBar.value = bb.get_data("tool_hp");








func _on_collector_entered(area: Area2D) -> void: ###
	if area.has_method("get_type"):
		var type: String = area.get_type();
		match type:
			"wood_resource":
				var material_type: String = bb.get_data("material_type");
				var is_carrying: bool = bb.get_data("is_carrying_material");
				if material_type == type && is_carrying == false:
					if area.has_method("collect_wood"):
						bb.set_data("material_value", area.collect_wood());
						bb.set_data("is_carrying_material", true);
			"ore_resource":
				var material_type: String = bb.get_data("material_type");
				var is_carrying: bool = bb.get_data("is_carrying_material");
				if material_type == type && is_carrying == false:
					if area.has_method("collect_ore"):
						bb.set_data("material_value", area.collect_ore());
						bb.set_data("is_carrying_material", true);
			"stockpile":
				var material_type: String = bb.get_data("material_type");
				var is_carrying: bool = bb.get_data("is_carrying_material");
				if area.has_method("add_to_storage"):
					area.add_to_storage(material_type, bb.get_data("material_value"))
					bb.set_data("material_value", 0);
					bb.set_data("is_carrying_material", false);
			"forge":
				var tool_hp: int = bb.get_data("tool_hp");
				if tool_hp <= 0 && area.has_method("repair_tool"):
					area.repair_tool(bb);


func _on_tool_hit(area: Area2D) -> void:
	if area.has_method("get_type"):
		var type: String = area.get_type();
		match type:
			"boulder_ore":
				var source_type: String = bb.get_data("source_type");
				if source_type == type:
					if area.has_method("drop_ore"):
						var drop: bool = area.drop_ore();
						if drop == true:
							bb.set_data("tool_hp", bb.get_data("tool_hp") - 1);
			"wood_tree":
				var source_type: String = bb.get_data("source_type");
				if source_type == type:
					if area.has_method("drop_wood"):
						var drop: bool = area.drop_wood();
						if drop == true:
							bb.set_data("tool_hp", bb.get_data("tool_hp") - 1);


func _on_animation_finished(anim_name: StringName) -> void:
	bb.set_data("finished_animation_name", anim_name);




func collect():
	if %CollectorShape.disabled == true:
		%CollectorShape.disabled = false;

func get_type() -> String:
	return "gatherer";
