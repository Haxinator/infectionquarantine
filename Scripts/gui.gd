extends Control

@onready var folder_pop_up = $"Folder Pop Up"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_computer_pressed() -> void:
	print("Computer Pressed!")


func _on_symptoms_folder_toggled(toggled_on: bool) -> void:
	if toggled_on:
		folder_pop_up.visible = true
		AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.FOLDER_OPEN)
	else:
		folder_pop_up.visible = false
		AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.FOLDER_CLOSE)


func _on_thermometer_pressed() -> void:
	pass # Replace with function body.


func _on_stethoscope_pressed() -> void:
	pass # Replace with function body.


func _on_syringe_pressed() -> void:
	pass # Replace with function body.
