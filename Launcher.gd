@tool
extends Point

class_name Launcher

@export var range_radius: float = 50
@export var range_color: Color = Color.LIGHT_BLUE

func _ready() -> void:
	super._ready()
	
	for child in get_children():
		if child is Positioner:
			print("Child angle: %s" % rad_to_deg(child.position.angle_to(position)))
	
func _draw():
	draw_circle(Vector2(), range_radius, range_color)
	
	for child in get_children():
		if child is Positioner:
			draw_line(Vector2(), child.position, child.connector_color, 2, true)
			
	super._draw()
