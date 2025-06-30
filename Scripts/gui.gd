extends Control

@onready var folder_pop_up = $"Folder Pop Up"

signal sendQuarantine
signal sendDorm
signal thermometerSelect
signal stethoscopeSelect
signal needleSelect
signal showBlood

var needleIsFull: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_computer_pressed() -> void:
	if needleIsFull:
		showBlood.emit()
		needleIsFull = false
	print("TEST: Computer Pressed")

func setNeedleFull():
	needleIsFull = true

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


func _on_healthy_ui_pressed() -> void:
	sendDorm.emit()


func _on_quarantine_ui_pressed() -> void:
	sendQuarantine.emit()


func _on_item_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	if index == 0:
		#therm
		thermometerSelect.emit()
	if index == 1:
		#Needle
		needleSelect.emit()
	if index == 2:
		#steth
		stethoscopeSelect.emit()


func _on_computer_animated_pressed() -> void:
	if needleIsFull:
		showBlood.emit()
		needleIsFull = false
	print("TEST: Computer Pressed")
	get_node("Clickable Areas/ComputerAnimated/AnimatedSprite2D").animation = "healthy"
	get_node("Clickable Areas/ComputerAnimated/AnimatedSprite2D").play()
	get_node("Clickable Areas/ComputerAnimated").position.x -= 150
	get_node("Clickable Areas/ComputerAnimated").scale = Vector2(0.4,0.4)
