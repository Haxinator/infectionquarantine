extends Control

signal dialogueStart

@onready var scoreboard = get_node("GUI/Scoreboard")

const nurse = preload("res://Scenes/NPCS/nurse.tscn")
const patient = preload("res://Scenes/NPCS/Patient.tscn")
const emptyNeedle = preload("res://Assets/Art/UI assets/Holding Needle Hand.png")
const fullNeedle = preload("res://Assets/Art/UI assets/Holding Needle Hand (with liquid).png")
const hand = preload("res://Assets/Art/UI assets/Hand cursor.png")
const tempHand = preload("res://Assets/Art/UI assets/Temp Hand.png")
const stethoscopeHand = preload("res://Assets/Art/UI assets/Stethoscope Hand.png")

var seeingPatient = true
var infront = null
var isSick = false
var inCorrectGuessCount = 0
var correctGuessCount = 0
var score = 0
enum Tools {
	NONE,
	STETH,
	THERM,
	NEEDLE,
	FULLNEEDLE
}
var selectedTool = Tools.NONE

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
	setTool(selectedTool)

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

'''
func walkInAnimation():
	var walk = create_tween()
	
	infront.position = 1.6*get_viewport_rect().size/4
	infront.position.y += 100
	
	var endPos = get_viewport_rect().size/2
	#walk.tween_property(infront, "position", endPos, 0.2)
'''
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
	#hide any popups
	if Input.is_action_just_pressed("left_mouse"):
		get_node("GUI/Control2").visible = false
	if not seeingPatient:
		seeingPatient = true
		var patientCpy = patient.instantiate()
		infront = patientCpy
		#patientCpy.visible = true
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
		
		#walkInAnimation()
		patientCpy.connect("fillNeedle", setNeedleFull)
		patientCpy.showID()

func runDiagolue(dialogue: String):
	dialogueStart.emit()
	Dialogic.start(dialogue)

func setNeedleFull():
	Input.set_custom_mouse_cursor(fullNeedle)
	selectedTool = Tools.FULLNEEDLE
	get_node("GUI").setNeedleFull()

func _on_gui_send_dorm() -> void:
	if isSick:
		inCorrectGuessCount += 1
		score -=1
	else:
		score +=1
		correctGuessCount += 1	
	scoreboard.text = "Score: " + str(score)
	sendDorm()


func _on_gui_send_quarantine() -> void:
	if isSick:
		score += 1
		correctGuessCount += 1
	else:
		inCorrectGuessCount += 1
		score -= 1
	scoreboard.text = "Score: " + str(score)
	sendQuarantine()


func _on_gui_needle_select() -> void:
	if selectedTool == Tools.NEEDLE:
		setTool(Tools.NONE)
		get_node("GUI/Clickable Areas/ItemList").deselect_all()
		Input.set_custom_mouse_cursor(hand)
	else:
		setTool(Tools.NEEDLE)
		Input.set_custom_mouse_cursor(emptyNeedle)
	print(str(selectedTool))


func _on_gui_stethoscope_select() -> void:
	if selectedTool == Tools.STETH:
		setTool(Tools.NONE)
		get_node("GUI/Clickable Areas/ItemList").deselect_all()
		Input.set_custom_mouse_cursor(hand)
	else:
		setTool(Tools.STETH)
		Input.set_custom_mouse_cursor(stethoscopeHand)
	print(str(selectedTool))


func _on_gui_thermometer_select() -> void:
	if selectedTool == Tools.THERM:
		setTool(Tools.NONE)
		get_node("GUI/Clickable Areas/ItemList").deselect_all()
		Input.set_custom_mouse_cursor(hand)
	else:
		setTool(Tools.THERM)
		Input.set_custom_mouse_cursor(tempHand)
	print(str(selectedTool))

func setTool(tool):
	selectedTool = tool
	infront.setTool(tool)


func _on_gui_show_blood() -> void:
	setTool(Tools.NEEDLE)
	Input.set_custom_mouse_cursor(emptyNeedle)
	var GUI = get_node("GUI/Control2")
	var anim = GUI.get_node("AnimatedSprite2D")
	if infront.getBlood():
		anim.animation = "sick"
	else:
		anim.animation = "healthy"
	GUI.visible = true
	anim.play()
	GUI.get_node("Timer").start()
