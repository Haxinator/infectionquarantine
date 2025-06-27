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
var firstNames = ["Frankie", "Jackie", "Brodie", "Charlie", "Ash", "Robin", "Blake", "Jett", "Sage", "Ridley", "Spencer", "Basil", "Sunny", "Tiger", "Katie", "Stevie", "Andie", "Billie", "Jessie", "Ollie", "Kris", "Kim", "Alex", "Bailey", "Bellamy", "Adrian", "Aubrey", "Bryce", "Francis", "Jean", "London", "Paris", "Pat", "Remy", "Ricky", "Rumi", "Sidney", "Terry", "Kanye", "Taylor"]
var LastNames = ["Quinn", "Alexander", "Griffin", "Hope", "Cassidy", "Jenkins", "Perry", "Smith", "Johnson", "Brown", "Garcia", "Miller", "Davis", "Jackson", "Lee", "Robinson", "Young", "King", "White", "Pinkman", "Cook", "Murphy", "Edwards", "Wood", "Blight", "Bacon", "Zion", "Swap", "Mctosh", "Swift", "West", "East"]
var characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ "
var notFeelingSick = ["I feel fine.", "I'm feeling good.", "I'm doing fine.", "Pretty good.","I'm doing well.", "I'm alright.", "Can't complain.", "Not bad.", "Never better.", "I don't feel sick.", "I haven't noticed anything.", "I think I'm ok."]
var locations = ["Park", "Recreational area", "Rec Room", "Kitchen", "Canteen", "Dormatory", "Gym", "Library", "Common Area", "Meeting Room", "Power & Utility Room", "Utility Room", "Infirmary"]
var feelingSick = ["I feel like throwing up.", "I feel dizzy.", "I feel sick.", "I haven't been sleeping.", "I haven't been sleeping, I've been up all night coughing."]
var actions = ["I was working in the", "I was walking around the", "I was just hanging out in the", "I was hanging out with my friends in the", "I've was reading a book in the", "I was in the"]
var aggressive1 = ["Why do I need to tell you my name and date of birth? It's already on my ID card.", "This seems excessive.", "..." ,"Is this really necessary?", "I have better things I could be doing with my time."]
var aggressive2 = ["Yes people are dying. What are you doing to help them? Playing judge, jury and executioner?", "You'll kill me like the rest.", "I want nothing to do with you.", "You're nothing but a murder.", "Stop talking to me.", "Get away from me."]
var anxious1 = ["Why is something wrong?", "Is something wrong?", "Why are you looking at me like that?", "Did I do something wrong?"]
var anxious2 = ["Please, please...", "What is it? What's wrong with me?", "I'm not going to die right?", "No, no, no... this can't be happening.", "Please don't let me die."]

#Most likely randomise character here.
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DOB = getDOB()
	patientName = getName()
	aggression = randi_range(0,2)
	aggression = 2
	anxiety = randi_range(0,2)
	variant = randi_range(0,2)
	
	#must be called to set dialogic vars accordingly
	setDialogicVars()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setDialogicVars():
	#set name and DOB in dialogic
	Dialogic.VAR.Patient.name = patientName
	Dialogic.VAR.Patient.dob = DOB
	Dialogic.VAR.Patient.aggression = aggression
	Dialogic.VAR.Patient.anxiety = anxiety
	Dialogic.VAR.Patient.variant = variant
	Dialogic.VAR.Patient.chance = randi_range(0,100)
	Dialogic.VAR.Patient.wasConvinced = false
	Dialogic.VAR.Patient.wasConvinced2 = false
	Dialogic.VAR.Patient.aggressive1 = aggressive1[randi_range(0, len(aggressive1)-1)]
	Dialogic.VAR.Patient.aggressive2 = aggressive2[randi_range(0, len(aggressive2)-1)]
	Dialogic.VAR.Patient.anxious1 = anxious1[randi_range(0, len(anxious1)-1)]
	Dialogic.VAR.Patient.anxious2 = anxious2[randi_range(0, len(anxious2)-1)]

func getName():
	var first = randi_range(0, len(firstNames)-1)
	var last = randi_range(0, len(LastNames)-1)
	var mid = randi_range(0,len(characters)-1)
	
	if mid == len(characters)-1:
		return firstNames[first] + " " + LastNames[last]
	else:
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
	get_node("Sprite2D").texture = load("res://Assets/Art/" + patient + ".PNG")
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
