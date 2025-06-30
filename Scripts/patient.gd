extends Node2D

signal dialogueStart

#Patient Info
var firstName: String = ""
var midName: String = ""
var lastName: String = ""
var patientName: String = ""
var DOB: String = "00/00/00"
var DOBArray = []
var temp: float = -1
var heartRate : int = -1
var bloodContaminated = false
var confused = false
var isSick: bool = false
var patient: String = ""
var disorder = false
var ID = null
var label = null
var sick = false

#patient control params
var aggression = -1
var anxiety = -1
var variant = -1

#Portraits
const TOTAL_HEALTHY = 15
const TOTAL_SICK = 1

#Dialogue
var firstNames = ["Frankie", "Jackie", "Brodie", "Charlie", "Ash", "Robin", "Blake", "Jett", "Sage", "Ridley", "Spencer", "Basil", "Sunny", "Tiger", "Katie", "Stevie", "Andie", "Billie", "Jessie", "Ollie", "Kris", "Kim", "Alex", "Bailey", "Bellamy", "Adrian", "Aubrey", "Bryce", "Francis", "Jean", "London", "Paris", "Pat", "Remy", "Ricky", "Rumi", "Sidney", "Terry", "Kanye", "Taylor"]
var lastNames = ["Quinn", "Alexander", "Griffin", "Hope", "Cassidy", "Jenkins", "Perry", "Smith", "Johnson", "Brown", "Garcia", "Miller", "Davis", "Jackson", "Lee", "Robinson", "Young", "King", "White", "Pinkman", "Cook", "Murphy", "Edwards", "Wood", "Blight", "Bacon", "Zion", "Swap", "Mctosh", "Swift", "West", "East"]
var characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ "
var notFeelingSick = ["I feel fine.", "I'm feeling good.", "I'm doing fine.", "I'm pretty good.","I'm doing well.", "I'm alright.", "I can't complain.", "I'm not bad.", "I've never been better.", "I don't feel sick.", "I haven't noticed anything out of the ordinary.", "I think I'm ok."]
var locations = ["Park", "Recreational area", "Rec Room", "Kitchen", "Canteen", "Dormatory", "Gym", "Library", "Common Area", "Meeting Room", "Power & Utility Room", "Utility Room", "Infirmary"]
var feelingSick = ["I feel like throwing up.", "I feel dizzy.", "I feel sick.", "I haven't been sleeping.", "I haven't been sleeping, I've been up all night coughing."]
var actions = ["I was working in the", "I was walking around the", "I was just hanging out in the", "I was hanging out with my friends in the", "I've was reading a book in the", "I was in the"]
var aggressive1 = ["Why do I need to tell you my name and date of birth? It's already on my ID card.", "This seems excessive.", "..." ,"Is this really necessary?", "Seriously?", "I have better things I could be doing with my time."]
var aggressive2 = ["Yes people are dying. What are you doing to help them? Playing judge, jury and executioner?", "You'll kill me like the rest.", "I want nothing to do with you.", "You're nothing but a murder.", "Stop talking to me.", "Get away from me."]
var anxious1 = ["Why is something wrong?", "Is something wrong?", "What's the matter?", "Did I do something wrong?"]
var anxious2 = ["Please, please...", "What is it? What's wrong with me?", "I'm not going to die right?", "No, no, no... this can't be happening.", "Please don't let me die."]
var symptoms = ["I'm dizzy. ", "My head is killing me. ", "I have a massive migraine. ", "I have a headache. ", "I feel nauseous. ", "I feel generally sick. ", "I have aches and pains all over. ", "I haven't been sleeping. ", "I've been violently coughing. ", "Sometimes I feel I'm out of breath. ", "I've been getting hot and cold flushes. ", "I can't cool down. ", "I feel weird. "]
var headache = [ "My head is killing me. ", "I have a massive migraine. ", "I have a headache. "]
var tired = ["I'm dizzy. ", "I feel tired. ", "I haven't been sleeping. "]
var otherIllness = false

#Most likely randomise character here.
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#DOB = getDOB()
	#patientName = getName()
	aggression = randi_range(0,2)
	anxiety = randi_range(0,2)
	variant = randi_range(0,2)
	disorder = true if randi() % 100 < 30 else false
	
	# Sets the sprite for the character portrait on _ready
	patient = "Patient" + str(randi_range(1, TOTAL_HEALTHY))
	get_node("Sprite2D").texture = load("res://Assets/Art/Characters/Patients/" + patient + ".png")
	
	#must be called to set dialogic vars accordingly
	setDialogicVars()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setDialogicVars():
	#set name and DOB in dialogic
	#Dialogic.VAR.Patient.dob = DOB
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
	var last = randi_range(0, len(lastNames)-1)
	var mid = randi_range(0,len(characters)-1)
	
	firstName = firstNames[first]
	midName = characters[mid]
	lastName = lastNames[last]
	print(firstName + " " + midName + " " + lastName)
	
	if mid == len(characters)-1:
		return firstName + " " + lastName
	else:
		return firstName + " " + midName + " " + lastName

func confuseName():
	var fullName = [firstName, midName, lastName]
	var index = randi_range(0, len(fullName)-1)
	var new = ""
	
	if index == 0:
		var newIndex = randi_range(0, len(firstNames)-1)
		new = firstNames[newIndex]
		if new == fullName[index]:
			new = firstNames[(newIndex+1) % len(firstNames)]
	if index == 1:
		var newIndex = randi_range(0, len(characters)-1)
		new = characters[newIndex]
		if new == fullName[index]:
			new = characters[(newIndex+1) % len(characters)]
	if index == 2:
		var newIndex = randi_range(0, len(lastNames)-1)
		new = lastNames[newIndex]
		if new == fullName[index]:
			new = lastNames[(newIndex+1) % len(lastNames)]
	fullName[index] = new
	
	if fullName[1] == " ":
		Dialogic.VAR.Patient.name = (fullName[0] + " " + fullName[2])
	else:
		Dialogic.VAR.Patient.name = (fullName[0] + " " +  fullName[1] + " " + fullName[2])

func confuseDOB():
	var index = randi_range(0,2)
	
	if index == 0:
		var new = randi_range(0,31)
		if new == DOBArray[index]:
			new = (new+1)%31
		DOBArray[index] = new
		
	if index == 1:
		var new = randi_range(0,12)
		if new == DOBArray[index]:
			new = (new+1)%12
		DOBArray[index] = new
		
	if index == 2:
		var new = randi_range(2000,2100)
		if new == DOBArray[index]:
			new += 1
		DOBArray[index] = new

	Dialogic.VAR.Patient.dob = DOBtoString()

func DOBtoString():
	var string = ""
	var day = DOBArray[0]
	var month = DOBArray[1]
	var year = DOBArray[2]
	
	if day < 10:
		string += "0"
	string += str(day) + "/"
	
	if month < 10:
		string += "0"
	string += str(month) + "/"
	string += str(year)
	
	return string

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
	
	DOBArray.append(day)
	DOBArray.append(month)
	DOBArray.append(year)
	
	return string + str(year)

func setHealthy():
	#Need to set name here otherwise confuse name won't work
	patientName = getName()
	Dialogic.VAR.Patient.name = patientName
	DOB = getDOB()
	Dialogic.VAR.Patient.dob = DOB
	sick = false
	bloodContaminated = false
	heartRate = randi_range(60, 100)
	temp = randf_range(36, 37.9)
	otherIllness = true if randi_range(0,1) == 1 else false
	
	#increase heart rate if angry or anxious
	if anxiety == 2 or aggression == 2:
		heartRate = randi_range(90, 120)
	if anxiety == 1 or aggression == 1:
		heartRate = randi_range(80, 110)
	
	if randi_range(0,100)*anxiety > 50:
		#make them say the wrong name or DOB if nervous
		var state = randi()%3
		if state == 1:
			confuseName()
		elif state == 2:
			confuseDOB()
		else:
			confuseName()
			confuseDOB()

	#false positive.
	if disorder:
		if randi() % 100 < 80:
			bloodContaminated = true
	
	#change of high temperature if angry
	if aggression == 2:
		temp = randf_range(36, 39)
	temp = snapped(temp, 0.01)
	
	Dialogic.VAR.Patient.location = locations[randi_range(0, len(locations)-1)]
	Dialogic.VAR.Patient.action = actions[randi_range(0, len(actions)-1)]
	Dialogic.VAR.Patient.feeling = notFeelingSick[randi_range(0, len(notFeelingSick)-1)]
	
	var symptoms = ""
	
	if otherIllness:
		symptoms += generateOtherIllness()
	if anxiety == 2:
		Dialogic.VAR.Patient.feeling = (symptoms + generateSymptoms(randi_range(1,4)))
	elif anxiety == 1:
		Dialogic.VAR.Patient.feeling = (symptoms + generateSymptoms(randi_range(0,2)))
		
	if confused:
		var state = randi()%3
		if state == 1:
			confuseName()
		elif state == 2:
			confuseDOB()
		else:
			confuseName()
			confuseDOB()

func generateOtherIllness():
	if randi_range(0,1) == 1:
		confused = true
		return tired[randi_range(0, len(tired)-1)]
	else:
		temp = snapped(randf_range(38, 40),0.01)
		return headache[randi_range(0, len(headache)-1)]

func generateSymptoms(symptomsRequired):
	var string = ""
	var indices = []
	
	symptoms.shuffle() #array is small enough it shouldn't matter.
	
	for i in range(symptomsRequired):
		string += symptoms[i]
	
	return string

func setSick():
	#Need to set name here otherwise confuse name won't work
	patientName = getName()
	Dialogic.VAR.Patient.name = patientName
	DOB = getDOB()
	Dialogic.VAR.Patient.dob = DOB
	sick = true
	heartRate = randi_range(60, 140)
	temp = snapped(randf_range(36, 40),0.01)
	#50% of false negative
	bloodContaminated = true if randi()%2 == 1 else false 
	confused = true if randi()%2 == 1 else false 
	var symptomsRequired = randi_range(4, 5)
	var sympCount = 0

	if temp >= 38:
		sympCount +=1
	if heartRate > 120:
		sympCount +=1
	if bloodContaminated:
		sympCount +=1
	if confused:
		sympCount+=1
		var state = randi()%3
		if state == 1:
			confuseName()
		elif state == 2:
			confuseDOB()
		else:
			confuseName()
			confuseDOB()
			
	
	
	symptomsRequired -= sympCount
	
	#dialogue = "PatientSick" + str(randi_range(1, TOTAL_SICK))
	#Dialogic.VAR.Patient.feeling = feelingSick[randi_range(0, len(feelingSick)-1)]
	Dialogic.VAR.Patient.feeling = generateSymptoms(symptomsRequired)
	Dialogic.VAR.Patient.location = locations[randi_range(0, len(locations)-1)]
	Dialogic.VAR.Patient.action = actions[randi_range(0, len(actions)-1)]

#update ID based on patient data.

func showTemp():
	removeLabel()
	
	label = load("res://Scenes/Misc/TemperatureLabel.tscn")
	label = label.instantiate()
	label.get_node("Label").text = "temp: " + str(temp)
	label.position = get_viewport_rect().size/2
	label.position.x += 300
	
	get_tree().get_root().add_child(label)

func showBlood():
	removeLabel()
	
	label = load("res://Scenes/Misc/BloodLabel.tscn")
	label = label.instantiate()
	label.get_node("Label").text = "Blood Contaminated: " + str(bloodContaminated)
	label.position = get_viewport_rect().size/2
	label.position.x += 300
	
	get_tree().get_root().add_child(label)

func showHeartRate():
	removeLabel()
	
	label = load("res://Scenes/Misc/HeartRateLabel.tscn")
	label = label.instantiate()
	label.get_node("Label").text = "BPM: " + str(heartRate)
	label.position = get_viewport_rect().size/2
	label.position.x += 300
	
	get_tree().get_root().add_child(label)

func removeLabel():
	if label != null:
		label.queue_free()

func showID():
	#var id = load("res://dialog/IDCards/layered_portrait_id1.tscn")
	var id = load("res://Scenes/Draggable/IDCard.tscn")
	var idCpy = id.instantiate()
	ID = idCpy
	idCpy.get_node("CardImage").texture = load("res://Assets/Art/UI assets/ID Cards/" + patient + " ID.png")
	idCpy.get_node("dob").text = DOB
	idCpy.get_node("name").text = patientName
	idCpy.get_node("Disorder Text").visible = true if disorder else false
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
	removeLabel()
