extends Node2D

signal dialogueStart

const nurse = preload("res://Scenes/nurse.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var nurseCpy = nurse.instantiate()
	Dialogic.signal_event.connect(DialogicSignal)
	nurseCpy.position = get_viewport_rect().size/2
	add_child(nurseCpy)
	runDiagolue("NurseIntro")

func DialogicSignal(arg: String):
	if arg == "WalkAway":
		get_node("Nurse/AnimationPlayer").play("WalkAway")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func runDiagolue(dialogue: String):
	dialogueStart.emit()
	Dialogic.start(dialogue)
