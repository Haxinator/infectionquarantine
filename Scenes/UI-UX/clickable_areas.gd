extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#dynamic placement of clickable areas.
	var screenPos = get_viewport_rect().size
	var clipboardy = get_viewport_rect().size.y/8
	
	screenPos.x = get_viewport_rect().size.x/3
	get_node("Healthy UI").position.x = 2.2*get_viewport_rect().size.x/8
	get_node("Healthy UI").position.y = clipboardy
	print(get_node("Healthy UI").position.y)

	get_node("Quarantine UI").position.x = 5 * get_viewport_rect().size.x/8
	get_node("Quarantine UI").position.y = clipboardy
	
	get_node("Symptoms File").position.x = 7*screenPos.x/8
	get_node("Symptoms File").position.y = 6.1*screenPos.y/8
	
	get_node("Computer").position.x = 2.15*screenPos.x
	get_node("Computer").position.y = 3.8*screenPos.y/8

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
