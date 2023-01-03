extends Node2D

class_name Point

const DRAG_RADIUS: float = 1000
const RADIUS_BUFFER: float = 1 # makes it slightly easier to grab nodes

@export var color: Color = Color.BLACK

@export var radius: float = 8:
	set(_radius):
		radius = _radius
		shape_radius = radius

var shape_radius: float:
	get:
		if $area/shape and $area/shape.shape:
			return $area/shape.shape.radius - RADIUS_BUFFER
		return radius
	set(radius):
		if $area/shape and $area/shape.shape:
			$area/shape.shape.radius = radius + RADIUS_BUFFER

func set_disabled(disabled: bool) -> void:
	$area/shape.disabled = disabled

func disable() -> void:
	set_disabled(true)

func enable() -> void:
	set_disabled(false)

func _ready() -> void:
	$area/shape.shape = CircleShape2D.new()
	shape_radius = radius

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	draw_circle(Vector2(), radius, color)

func _on_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventScreenTouch:
		if event.is_pressed():
			# increase the collision circle radius while dragging
			# ensures that dragging doesn't stop if the mouse leaves the points radius
			shape_radius = DRAG_RADIUS
			Points.disable_all_except(self)
		else:
			shape_radius = radius
			Points.enable()

	if event is InputEventScreenDrag:
		if shape_radius != DRAG_RADIUS:
			return

		var current_position = event.position
		var parent = get_parent()

		if parent is Node2D:
			current_position = parent.to_local(event.position)

		position = current_position

