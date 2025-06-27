extends Node2D

signal dialogueStart
var patientName: String = ""
var DOB: String = "00/00/00"
var temp: float = -1
var heartRate : int = -1
var isSick: bool = false
var patient: String = ""
var ID = null

var aggression = -1
var anxiety = -1
var variant = -1

const TOTAL_HEALTHY = 2
const TOTAL_SICK = 1
var firstNames = ["Frankie", "Jackie", "Brodie", "Charlie", "Zara", "Robin"]
var LastNames = ["Quinn", "Blight", "Bacon", "Zion", "Swap", "Mctosh"]
var characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ "
var notFeelingSick = ["I feel fine.", "never better.", "I don't feel sick at all.", "I haven't noticed anything.", "I think I'm ok."]
var locations = ["Park", "Recreational area", "Rec Room", "Kitchen", "Canteen", "Dormatory", "Gym", "Library", "Common Area"]
var feelingSick = ["I feel like throwing up.", "I feel dizzy.", "I feel sick.", "I haven't been sleeping, I've been up all night coughing."]
var actions = ["I was working in the", "I was hanging out with my friends in the", "I've was reading a book in the", "I was in"]

#Most likely randomise character here.
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DOB = getDOB()
	patientName = getName()
	aggression = randi_range(0,2)
	anxiety = randi_range(0,2)
	variant = randi_range(0,2)
	
	#set name and DOB in dialogic
	Dialogic.VAR.Patient.name = patientName
	Dialogic.VAR.Patient.dob = DOB
	Dialogic.VAR.Patient.aggression = aggression
	Dialogic.VAR.Patient.anxiety = anxiety
	Dialogic.VAR.Patient.variant = variant

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func getName():
	var first = randi_range(0, len(firstNames)-1)
	var last = randi_range(0, len(LastNames)-1)
	var mid = randi_range(0,len(characters)-1)
	return firstNames[first] + " " + characters[mid] + " " + LastNames[last] 

#overly complex funcion for determining DOB
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
	var string = ""
	
	if day < 10:
		string += "0"
	string += str(day) + "/"
	
	if month < 10:
		string += "0"
	string += str(month) + "/"
	
	return string + str(year)

func setHealthy():
	heartRate = randi_range(60, 100)
	temp = randf_range(36, 37.9)
	patient = "Patient" + str(randi_range(1, TOTAL_HEALTHY))
	get_node("Sprite2D").texture = load("res://Assets/" + patient + ".PNG")
	Dialogic.VAR.Patient.feeling = notFeelingSick[randi_range(0, len(notFeelingSick)-1)]
	Dialogic.VAR.Patient.location = locations[randi_range(0, len(locations)-1)]
	Dialogic.VAR.Patient.action = actions[randi_range(0, len(actions)-1)]

func setSick():
	heartRate = randi_range(60, 100)
	temp = randf_range(38, 42)
	#dialogue = "PatientSick" + str(randi_range(1, TOTAL_SICK))
	Dialogic.VAR.Patient.feeling = feelingSick[randi_range(0, len(feelingSick)-1)]
	Dialogic.VAR.Patient.location = locations[randi_range(0, len(locations)-1)]
	Dialogic.VAR.Patient.action = actions[randi_range(0, len(actions)-1)]
#update ID based on patient data.
func showID():
	var id = load("res://dialog/IDCards/layered_portrait_id1.tscn")
	var idCpy = id.instantiate()
	ID = idCpy
	idCpy.get_node("properties/dob").text = DOB
	idCpy.get_node("properties/name").text = patientName
	idCpy.position = get_viewport_rect().size / 2
	idCpy.position.x -= 400
	
	get_tree().get_root().add_child(idCpy)

#removes ID from view
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
