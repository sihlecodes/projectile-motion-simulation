extends Node

func _ready() -> void:
	var grid = $ui/container/column/grid

	grid.get_node("steps_slider").value = $PathRenderer.draw_steps

func _on_reset_pressed() -> void:
	$camera.offset = Vector2()
	$camera.zoom = Vector2.ONE

	$PathRenderer.position = Vector2()

func _on_container_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("zoom_in"):
		$camera.zoom *= 1.1

	if event.is_action_pressed("zoom_out"):
		$camera.zoom *= 0.9

	if event is InputEventScreenDrag:
		# when all points are enabled it means none of them are currently being manipulated
		# i.e. it's safe to change the offset
		if Points.all_enabled():
			$camera.offset -= event.relative / $camera.zoom


func _on_clear_pressed() -> void:
	for child in $PathRenderer.get_children().slice(2):
		child.queue_free()

func _on_range_slider_value_changed(value: float) -> void:
#	$PathRenderer.
	pass

func _on_steps_slider_value_changed(value: float) -> void:
	$PathRenderer.draw_steps = value
