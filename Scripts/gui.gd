extends Control

@onready var folder_pop_up = $"Folder Pop Up"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_computer_pressed() -> void:
	pass # Replace with function body.


func _on_symptoms_folder_toggled(toggled_on: bool) -> void:
	if toggled_on:
		folder_pop_up.visible = true
	else:
		folder_pop_up.visible = false


func _on_thermometer_pressed() -> void:
	pass # Replace with function body.


func _on_stethoscope_pressed() -> void:
	pass # Replace with function body.


func _on_syringe_pressed() -> void:
	pass # Replace with function body.
