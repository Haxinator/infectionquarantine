extends Control

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
	nurseCpy.position.y -= 60
	add_child(nurseCpy)
	runDiagolue("NurseIntro")
	infront = nurseCpy

func walkAwayAnimation():
	#dynamic walking animation using tweens
		var move = create_tween()
		#repeat bobbing tween forever
		var bob = create_tween().set_loops(INF)
		
		#move to end of screen
		var finalpos = get_viewport_rect().size
		finalpos.x += 200
		finalpos.y = finalpos.y/2 - 60
		if infront.name == "Patient":
			finalpos.y -= 20
		move.tween_property(infront, "position", finalpos, 1)
		
		#create looping bobbing effect
		bob.tween_property(infront, "position:y", finalpos.y-8, 0.2)
		bob.tween_property(infront, "position:y", finalpos.y+8, 0.2)

func DialogicSignal(arg: String):
	if arg == "WalkAway":
		walkAwayAnimation()
		seeingPatient = false
	if arg == "showID":
		infront.showID()
	if arg == "hideID":
		infront.removeID()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not seeingPatient:
		seeingPatient = true
		var patientCpy = patient.instantiate()
		infront = patientCpy
		patientCpy.visible = true
		patientCpy.position = get_viewport_rect().size/2
		patientCpy.position.y -= 80
		#patientCpy.get_node("AnimationPlayer").play("WalkIn")
		
		if randi() % 2 == 0:
			patientCpy.setHealthy()
		else:
			patientCpy.setSick()
		
		add_child(patientCpy)

func runDiagolue(dialogue: String):
	dialogueStart.emit()
	Dialogic.start(dialogue)
