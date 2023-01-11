extends Node

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("zoom_in"):
		$camera.zoom *= 1.1

	if event.is_action_pressed("zoom_out"):
		$camera.zoom *= 0.9

	if event is InputEventScreenDrag:
		# when all points are enabled it means none of them are currently being manipulated
		# i.e. it's safe to change the offset
		if Points.all_enabled():
			$camera.offset -= event.relative / $camera.zoom


func _on_reset_pressed() -> void:
	$camera.offset = Vector2()
	$camera.zoom = Vector2.ONE

	$PathRenderer.position = Vector2()
