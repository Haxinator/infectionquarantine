extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_go_down_mouse_entered() -> void:
	get_node("Camera2D").position.y += 648

func _on_go_up_mouse_entered() -> void:
	get_node("Camera2D").position.y -= 648


func _on_microsope_pressed() -> void:
	print("Microscope Pressed!")


func _on_symptoms_folder_pressed() -> void:
	print("Symptoms Folder Pressed!")
