extends Node2D

signal dialogueStart


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	runDiagolue("NurseIntro")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func runDiagolue(dialogue: String):
	dialogueStart.emit()
	Dialogic.start(dialogue)
