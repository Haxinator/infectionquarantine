extends Node2D

signal dialogueStart
var patientName: String = ""
var DOB: String = "00/00/00"
var temp: float = -1
var heartRate : int = -1
var isSick: bool = false
var dialogue: String = ""

const TOTAL_HEALTHY = 1
const TOTAL_SICK = 1

#Most likely randomise character here.
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setHealthy():
	heartRate = randi_range(60, 100)
	temp = randf_range(36, 37.9)
	dialogue = "Patient" + str(randi_range(1, TOTAL_HEALTHY))
	#get_node("Sprite2D").texture

func setSick():
	heartRate = randi_range(60, 100)
	temp = randf_range(38, 42)
	#dialogue = "PatientSick" + str(randi_range(1, TOTAL_SICK))

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	#if mouse button pressed
	if event is InputEventMouseButton and event.pressed:
		runDiagolue("Patient1")

func runDiagolue(dialogue: String):
	dialogueStart.emit()
	Dialogic.start(dialogue)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
