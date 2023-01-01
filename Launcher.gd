@tool
extends Point

class_name Launcher

@export var range_radius: float = 100
@export var range_color: Color = Color.LIGHT_BLUE

const GRAVITY: float = 9.8

func get_initial_velocity_from(positioner: Positioner) -> Vector2:
	return global_position - positioner.global_position

func get_velocity_at(x: float, initial_velocity := Vector2.ZERO) -> Vector2:
	return Vector2(initial_velocity.x, initial_velocity.y + GRAVITY * x)

func get_position_at(x: float, initial_velocity: Vector2) -> Vector2:
	return Vector2(initial_velocity.x, 0.5 * (initial_velocity + get_velocity_at(x, initial_velocity)).y * x)

func _ready() -> void:
	super._ready()

	for child in get_children():
		if child is Positioner:
			print("Velocity: %s" % get_initial_velocity_from(child))
			print("Angle: %s" % rad_to_deg(get_initial_velocity_from(child).angle()))
			print("Child angle: %s" % rad_to_deg(child.global_position.angle_to(global_position)))

func _process(_delta: float) -> void:
	super._process(_delta)
	position.y = clamp(position.y, 0, $"../Ground".position.y - radius * 2)

func _draw():
	draw_circle(Vector2(), range_radius, range_color)

	for child in get_children():
		if child is Positioner:
#			print("Angle: %s" % rad_to_deg(get_initial_velocity_from(child).angle_to(Vector2.LEFT)))
			draw_line(Vector2(), child.position, child.connector_color, 2, true)

	super._draw()
