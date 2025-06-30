extends RigidBody2D

var dragging = false
var of
var outOfView = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func dropItem():
	dragging = false
	freeze = false
	if outOfView:
		position = get_viewport_rect().size/2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if dragging and Input.is_action_pressed("left_mouse"):
		position = get_viewport().get_mouse_position() - of
	else:
		dropItem()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		freeze = true
		dragging = true
		of = get_viewport().get_mouse_position() - position
		
	elif event is InputEventMouseButton and not event.pressed:
		dropItem()


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	outOfView = true


func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	outOfView = false
