@tool
extends BasePoint

class_name PathRenderer

@export var range_radius: float = 100
@export var range_color: Color = Color.LIGHT_BLUE

const GRAVITY: float = 9.8
const VECTOR_LINE_WIDTH = 2
const VECTOR_HEAD_LENGTH = 15
const VECTOR_HEAD_ANGLE = PI / 3

@export var draw_steps = 5

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

	draw_polyline(points, path_color, 2, true)


func draw_vector(vector: Vector2, color: Color):
	draw_set_transform(Vector2.ZERO, vector.angle())

	var line_end = Vector2.RIGHT * vector.length()
	# draw body line
	draw_line(Vector2(), line_end, color, VECTOR_LINE_WIDTH, true)

	# draw arrow head lines
	draw_line(line_end, line_end - (Vector2.RIGHT * VECTOR_HEAD_LENGTH).rotated(VECTOR_HEAD_ANGLE/2), color, VECTOR_LINE_WIDTH, true)
	draw_line(line_end, line_end - (Vector2.RIGHT * VECTOR_HEAD_LENGTH).rotated(-VECTOR_HEAD_ANGLE/2), color, VECTOR_LINE_WIDTH, true)

	draw_set_transform(Vector2.ZERO)

func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		pass

func _process(delta: float) -> void:
	super._process(delta)
	position.y = clamp(position.y, -INF, $"../ground".position.y - radius * 2)

func _draw():
	draw_circle(Vector2(), range_radius, range_color)

	for child in get_children():
		if child is PathPoint:
			draw_line(Vector2(), child.position, child.connector_color, 2, true)

			var start_position = position
			var end_height = $"../ground".position.y
			var initial_velocity = get_initial_2d_velocity_from(child)

			draw_trajectory(start_position, end_height, initial_velocity, child.path_color)
			draw_vector(initial_velocity, child.connector_color)

	super._draw()
