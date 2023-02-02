extends BasePoint

class_name PathRenderer

const MAX_ADDITIONAL_RANGE = 100
const MIN_RANGE_RADIUS = 100

@export var range_radius: float = MIN_RANGE_RADIUS
@export var range_color: Color = Color.LIGHT_BLUE

const GRAVITY = 9.8
const VECTOR_LINE_WIDTH = 2
const VECTOR_HEAD_LENGTH = 15
const VECTOR_HEAD_ANGLE = PI / 3

const TRAJECTORY_LINE_WIDTH = 1

@export var draw_steps = 5

const MIN_DRAW_STEPS = 100

@onready var ground: = $"../ground"

signal node_created
signal node_deleted(node)
signal node_dragged

func add_child(node: Node, _force_readable_name: bool = false, _internal: int = INTERNAL_MODE_DISABLED):
	node.deleted.connect(func(): node_deleted.emit(node))
	super.add_child(node, _force_readable_name, _internal)

	node_created.emit()

func set_additional_range(percentage: float):
	range_radius = MIN_RANGE_RADIUS + MAX_ADDITIONAL_RANGE * percentage/100

func get_initial_2d_velocity_from(starting_point: PathPoint) -> Vector2:
	return global_position - starting_point.global_position

func get_height_at(time: float, initial_velocity: float) -> float:
	return initial_velocity * time + ((GRAVITY * pow(time, 2)) / 2)

func get_distance_at(time: float, velocity: float) -> float:
	return time * velocity

func get_travel_time(start_height: float, end_height: float, initial_velocity: Vector2) -> float:
	var height = start_height - end_height
	var half_acceleration = GRAVITY / 2

	# solve for time using the quadratic formula
	var a = half_acceleration
	var b = initial_velocity.y
	var c = height

	var time = (-b + sqrt(pow(b, 2) - 4 * a * c)) / (2 * a)

	return time

func draw_trajectory(start_position: Vector2, end_height: float, initial_velocity: Vector2, path_color: Color):
	var time = get_travel_time(start_position.y, end_height, initial_velocity)
	var points: Array[Vector2] = []

	for step in range(draw_steps):
		var time_per_step = time / draw_steps
		var current_time = step * time_per_step

		points.append(Vector2(current_time * initial_velocity.x, get_height_at(current_time, initial_velocity.y)))

	points.append(Vector2(time * initial_velocity.x, get_height_at(time, initial_velocity.y)))

	draw_polyline(points, path_color, Camera.unproject_scalar(TRAJECTORY_LINE_WIDTH), true)

func draw_vector_head(vector: Vector2, color: Color):
	var get_part: = func(angle: float):
		return vector - (Vector2.RIGHT * VECTOR_HEAD_LENGTH).rotated(vector.angle() - angle/2)

	var zoom_independent_width: = Camera.unproject_scalar(VECTOR_LINE_WIDTH)

	draw_line(vector, get_part.call(VECTOR_HEAD_ANGLE), color, zoom_independent_width, true)
	draw_line(vector, get_part.call(-VECTOR_HEAD_ANGLE), color, zoom_independent_width, true)

func draw_vector(vector: Vector2, color: Color):
	draw_line(Vector2(), vector, color, Camera.unproject_scalar(VECTOR_LINE_WIDTH), true)
	draw_vector_head(vector, color)

var spawning_point: PathPoint = null

func _on_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	var create_action_pressed: = Input.is_action_pressed("create_node")

	if event is InputEventScreenTouch:
		pressed = event.is_pressed()
		activate_exclusively(pressed)

		if pressed and create_action_pressed:
			spawning_point = preload("res://source/PathPoint.tscn").instantiate()
			spawning_point.disable()

		elif spawning_point and not pressed:
			if not spawning_point.get_parent():
				spawning_point.queue_free()

			spawning_point = null

		else:
			super._on_area_input_event(_viewport, event, _shape_idx)

	elif event is InputEventScreenDrag:
		if spawning_point and create_action_pressed:
			if not spawning_point.get_parent():
				# self is so that the overwritten definition of .add_child() is used.
				self.add_child(spawning_point)
				node_created.emit()

			spawning_point.position += Camera.unproject_vector(event.relative)
		else:
			super._on_area_input_event(_viewport, event, _shape_idx)

func _process(delta: float) -> void:
	super._process(delta)

	if ground != null:
		position.y = clamp(position.y, -INF, ground.position.y - radius * 2)

func _draw():
	draw_circle(Vector2(), range_radius, range_color)

	for child in get_children():
		if child is PathPoint:
			draw_line(Vector2(),
				child.position,
				child.connector_color, Camera.unproject_scalar(VECTOR_LINE_WIDTH), true)

			var start_position = position
			var end_height = ground.position.y
			var initial_velocity = get_initial_2d_velocity_from(child)

			draw_trajectory(start_position, end_height, initial_velocity, child.path_color)
			draw_vector(initial_velocity, child.connector_color)

	super._draw()
