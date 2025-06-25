extends Node2D

#Currently grabs the absolute path to the folder GUI. TODO: Update path to folder node
@onready var folder = get_node("GUI/CenterContainer/Folder")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_go_down_mouse_entered() -> void:
	get_node("Camera2D").position.y += 648

func _on_go_up_mouse_entered() -> void:
	get_node("Camera2D").position.y -= 648


func _on_microsope_pressed() -> void:
	print("Computer Pressed!")


func _on_symptoms_folder_toggled(toggled_on: bool) -> void:
	if toggled_on:
		folder.visible = true
	else:
		folder.visible = false
