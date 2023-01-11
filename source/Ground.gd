@tool
extends Line2D

class_name Ground

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	var camera = $"../camera"
	var window_size = get_viewport_rect().size

	var visible_size = window_size / camera.zoom

	var start_point = Vector2(-visible_size.x/2 + camera.offset.x, position.y)
	var end_point = Vector2(visible_size.x/2 + camera.offset.x, position.y)

	points = [start_point, end_point]
