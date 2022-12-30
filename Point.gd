@tool
extends Node2D

class_name Point

@export var color: Color = Color.BLACK
@export var radius: float = 5:
	set(_radius):
		radius = _radius
		set_shape_radius(radius)

@onready var _previous_position: Vector2 = position

func set_shape_radius(radius: float):
	if $area/shape.shape:
		$area/shape.shape.radius = radius
	
func _ready() -> void:
	$area/shape.shape = CircleShape2D.new()
	set_shape_radius(radius)
	
func _process(_delta: float) -> void:
	queue_redraw()
	
func _draw() -> void:
	draw_circle(Vector2(), radius, color)

func _on_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:		
	if event is InputEventScreenTouch:
		set_shape_radius(2000 if event.is_pressed() else radius)

	if event is InputEventScreenDrag:
		var current_position = event.position
		var parent = get_parent()
		
		if parent is Node2D:
			current_position = parent.to_local(event.position)
			
		position = current_position
