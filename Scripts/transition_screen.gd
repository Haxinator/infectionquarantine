extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.start("Transition")

func _on_dialogic_signal(argument: String):
	if argument == "game start":
		get_tree().change_scene_to_file("res://Scenes/Managers/GameManager.tscn")
