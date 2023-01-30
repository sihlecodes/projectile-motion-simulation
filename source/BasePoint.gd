extends Node2D

class_name BasePoint

const DRAG_RADIUS: float = 1000
const DRAG_RADIUS_BUFFER: float = 2 # makes it slightly easier to grab nodes

@export var color: Color = Color.BLACK
@export var radius: float = 8:
	set(_radius):
		radius = _radius
		shape_radius = radius

var pressed: = false

var shape_radius: float:
	set(radius):
		if $area/shape and $area/shape.shape:
			$area/shape.shape.radius = radius + DRAG_RADIUS_BUFFER

func disable() -> void:
	$area/shape.disabled = true

func enable() -> void:
	$area/shape.disabled = false

func activate_exclusively(activated: = true) -> void:
	shape_radius = DRAG_RADIUS if activated else radius

	if activated:
		Points.disable_all_except(self)
	else:
		Points.enable_all()

func _ready() -> void:
	$area/shape.shape = CircleShape2D.new()
	shape_radius = radius

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	draw_circle(Vector2(), radius, color)

func _on_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventScreenTouch:
		pressed = event.is_pressed()
		activate_exclusively(pressed)

	if event is InputEventScreenDrag:
		if not pressed:
			return

		position += Camera.unproject_vector(event.relative)
