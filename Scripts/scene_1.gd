extends Control

signal dialogueStart

const nurse = preload("res://Scenes/NPCS/nurse.tscn")
const patient = preload("res://Scenes/NPCS/Patient.tscn")

var seeingPatient = true
var infront = null
var isSick = false
var inCorrectGuessCount = 0
var correctGuessCount = 0
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Plays looped main_bgm when scene_1 loads
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.MAIN_BGM)
	
	var nurseCpy = nurse.instantiate()
	Dialogic.signal_event.connect(DialogicSignal)
	nurseCpy.position = get_viewport_rect().size/2
	#nurseCpy.position.y -= 40
	add_child(nurseCpy)
	runDiagolue("NurseIntro")
	infront = nurseCpy

func walkLeftAnimation():
	#dynamic walking animation using tweens
		var move = create_tween()
		#repeat bobbing tween forever
		var bob = create_tween().set_loops(INF)
		
		#move to end of screen
		var finalpos = get_viewport_rect().size
		finalpos.x = -200
		finalpos.y = finalpos.y/2 - 60
		if infront.name == "Patient":
			finalpos.y -= 20
		move.tween_property(infront, "position", finalpos, 1)
		
		#change position of off screen detector
		infront.get_node("VisibleOnScreenNotifier2D").position.x += 320
		
		#create looping bobbing effect
		bob.tween_property(infront, "position:y", finalpos.y-8, 0.2)
		bob.tween_property(infront, "position:y", finalpos.y+8, 0.2)

func walkRightAnimation():
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

func sendQuarantine():
	infront.get_node("CollisionShape2D").disabled = true
	if infront.name != "Nurse":
		infront.removeID()
	walkRightAnimation()
	seeingPatient = false

func sendDorm():
	infront.get_node("CollisionShape2D").disabled = true
	infront.removeID()
	walkLeftAnimation()
	seeingPatient = false

func DialogicSignal(arg: String):
	if arg == "WalkQuarantine":
		sendQuarantine()
	if arg == "WalkDorm":
		sendDorm()
	if arg == "showID":
		infront.showID()
	if arg == "hideID":
		infront.removeID()
	if arg == "HR":
		infront.showHeartRate()
	if arg == "BL":
		infront.showBlood()
	if arg == "temp":
		infront.showTemp()
	if arg == "hide":
		infront.removeLabel()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not seeingPatient:
		seeingPatient = true
		var patientCpy = patient.instantiate()
		infront = patientCpy
		patientCpy.visible = true
		patientCpy.position = get_viewport_rect().size/2
		#patientCpy.position.y -= 80
		#patientCpy.get_node("AnimationPlayer").play("WalkIn")
		
		if randi() % 2 == 0:
			patientCpy.setHealthy()
			isSick = false
			print("healthy")
		else:
			patientCpy.setSick()
			isSick = true
			print("sick")
			
		print("Score: " + str(score))
		print("incorrect guesses: " + str(inCorrectGuessCount))
		
		add_child(patientCpy)
		patientCpy.showID()

func runDiagolue(dialogue: String):
	dialogueStart.emit()
	Dialogic.start(dialogue)


func _on_gui_send_dorm() -> void:
	if isSick:
		inCorrectGuessCount += 1
		score -=1
	else:
		score +=1
		correctGuessCount += 1	
	sendDorm()


func _on_gui_send_quarantine() -> void:
	if isSick:
		score += 1
		correctGuessCount += 1
	else:
		inCorrectGuessCount += 1
		score -= 1
	sendQuarantine()
