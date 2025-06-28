extends RigidBody2D

var dragging = false
var of

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if dragging:
		position = get_viewport().get_mouse_position() - of

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		freeze = true
		dragging = true
		of = get_viewport().get_mouse_position() - position
		print("dragging")
		
	elif event is InputEventMouseButton and not event.pressed:
		freeze = false
		dragging = false
		print("released")
