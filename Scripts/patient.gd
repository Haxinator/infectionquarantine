extends Node2D

signal dialogueStart
var patientName: String = ""
var DOB: String = "00/00/00"
var temp: float = -1
var heartRate : int = -1
var isSick: bool = false
var patient: String = ""
var ID = null

const TOTAL_HEALTHY = 2
const TOTAL_SICK = 1
var firstNames = ["Frankie", "Jackie", "Brodie", "Charlie", "Zara", "Robin"]
var LastNames = ["Quinn", "Blight", "Bacon", "Zion", "Swap", "Mctosh"]
var characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ "

#Most likely randomise character here.
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DOB = getDOB()
	patientName = getName()
	
	#set name and DOB in dialogic
	Dialogic.VAR.Patient.name = patientName
	Dialogic.VAR.Patient.dob = DOB

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func getName():
	var first = randi_range(0, len(firstNames)-1)
	var last = randi_range(0, len(LastNames)-1)
	var mid = randi_range(0,len(characters)-1)
	return firstNames[first] + " " + characters[mid] + " " + LastNames[last] 

func getDOB():
	var month: int = randi_range(1,12)
	var year: int = randi_range(2020, 2080)
	
	#is leap year?
	var isLeap: bool = (year % 4 == 0 && year % 100 != 0) || year % 400
	#assume most common upper bound for day
	var upper: int = 31
	
	match month:
		2:
			upper = 29 if isLeap else 28
		4,6,9,11:
			upper = 30
	
	var day: int = randi_range(1, upper)
	
	return str(day)+ "/" + str(month) + "/" + str(year)

func setHealthy():
	heartRate = randi_range(60, 100)
	temp = randf_range(36, 37.9)
	patient = "Patient" + str(randi_range(1, TOTAL_HEALTHY))
	get_node("Sprite2D").texture = load("res://Assets/" + patient + ".PNG")

func setSick():
	heartRate = randi_range(60, 100)
	temp = randf_range(38, 42)
	#dialogue = "PatientSick" + str(randi_range(1, TOTAL_SICK))
	
func showID():
	var id = load("res://dialog/IDCards/layered_portrait_id1.tscn")
	var idCpy = id.instantiate()
	ID = idCpy
	idCpy.get_node("properties/dob").text = DOB
	idCpy.get_node("properties/name").text = patientName
	idCpy.position = get_viewport_rect().size / 2
	idCpy.position.x -= 400
	
	get_tree().get_root().add_child(idCpy)

func removeID():
	ID.queue_free()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	#if mouse button pressed
	if event is InputEventMouseButton and event.pressed:
		runDiagolue("Patient1")

func runDiagolue(dialogue: String):
	dialogueStart.emit()
	Dialogic.start(dialogue)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
