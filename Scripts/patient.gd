extends Node2D

signal dialogueStart

#Most likely randomise character here.
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	#if mouse button pressed
	if event is InputEventMouseButton and event.pressed:
		print("click!")
		runDiagolue("Patient1")

func runDiagolue(dialogue: String):
	dialogueStart.emit()
	Dialogic.start(dialogue)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print("free")
	queue_free()
