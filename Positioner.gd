@tool
extends Node2D

class_name Positioner

@export var color: Color = Color.BLACK
@export var radius: float = 5
@export var connector_color: Color = Color.CORNFLOWER_BLUE

func _process(delta: float) -> void:
	queue_redraw()
	print(rad_to_deg(get_parent().position.angle_to(global_position)))
	
func _draw() -> void:
	draw_circle(Vector2(), radius, color)
