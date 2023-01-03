@tool
extends Point

class_name Positioner

@export var connector_color: Color = Color.CORNFLOWER_BLUE

func _process(delta: float) -> void:
	var circumference_point = position.normalized() * get_parent().range_radius

	position.x = clamp(position.x, min(0, circumference_point.x), max(0, circumference_point.x))
	position.y = clamp(position.y, min(0, circumference_point.y), max(0, circumference_point.y))

	super._process(delta)
