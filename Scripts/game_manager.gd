extends Control

# Sets the number of patients to get through that day/level
@export var number_of_patients : int = 0

# Gets current level (follows the "x_1" level naming convention)
@onready var current_level_node : String = get_tree().get_first_node_in_group("Level").scene_file_path
@onready var current_level : int = int(current_level_node.get_slice("_", 1))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if current_level:
		print("level: " + str(current_level))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
