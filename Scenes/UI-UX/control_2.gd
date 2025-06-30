extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("AnimatedSprite2D").position = get_viewport_rect().size/2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	visible = false
