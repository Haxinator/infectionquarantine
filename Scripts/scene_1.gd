extends Node2D

signal dialogueStart

const nurse = preload("res://Scenes/NPCS/nurse.tscn")
const patient = preload("res://Scenes/NPCS/Patient.tscn")

var seeingPatient = true
var infront = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var nurseCpy = nurse.instantiate()
	Dialogic.signal_event.connect(DialogicSignal)
	nurseCpy.position = get_viewport_rect().size/2
	add_child(nurseCpy)
	runDiagolue("NurseIntro")
	infront = nurseCpy

func DialogicSignal(arg: String):
	if arg == "WalkAway":
		infront.get_node("AnimationPlayer").play("WalkAway")
		seeingPatient = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not seeingPatient:
		seeingPatient = true
		var patientCpy = patient.instantiate()
		infront = patientCpy
		patientCpy.visible = true
		patientCpy.position = get_viewport_rect().size/2
		#patientCpy.get_node("AnimationPlayer").play("WalkIn")
		
		if randi() % 2 == 0:
			patientCpy.setHealthy()
		else:
			patientCpy.setSick()
		
		add_child(patientCpy)

func runDiagolue(dialogue: String):
	dialogueStart.emit()
	Dialogic.start(dialogue)
