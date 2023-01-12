@tool
extends Line2D

class_name Ground

func _process(delta: float) -> void:
	var camera = $"../camera"
	var window_size = get_viewport_rect().size

	var visible_size = window_size / camera.zoom

	var start_point = Vector2(-visible_size.x/2 + camera.offset.x, 0)
	var end_point = Vector2(visible_size.x/2 + camera.offset.x, 0)

	points = [start_point, end_point]
