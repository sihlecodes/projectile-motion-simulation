extends Node

@onready var camera: = $camera
@onready var steps_slider = $ui/container/column/grid/steps_slider
@onready var path_renderer: = $PathRenderer
@onready var hint_label: = $ui/container/hint

func update_milestone_hint():
	var milestone: = Hints.current_milestone

	if milestone:
		hint_label.text = "hint: " + milestone.instruction
	else:
		hint_label.text = "hint: tutorial completed"

func _ready() -> void:
	steps_slider.value = path_renderer.draw_steps
	update_milestone_hint()

	Hints.milestone_completed.connect(_on_milestone_completed)

func _on_milestone_completed():
	var tween: = create_tween()

	tween.tween_property(hint_label, "modulate", Color.TRANSPARENT, 0.5)
	tween.tween_callback(update_milestone_hint)
	tween.tween_interval(0.2)
	tween.tween_property(hint_label, "modulate", Color.WHITE, 0.3)

func _on_reset_pressed() -> void:
	var animation_duration: = 0.2
	var tween = create_tween().set_parallel(true)

	tween.tween_property(camera, "offset", Vector2.ZERO, animation_duration)
	tween.tween_property(camera, "zoom", Vector2.ONE, animation_duration)
	tween.tween_property(path_renderer, "position", Vector2.ZERO, animation_duration)

func _on_container_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("zoom_in"):
		camera.zoom *= 1.1

	if event.is_action_pressed("zoom_out"):
		camera.zoom *= 0.9

	if event is InputEventPanGesture or event is InputEventScreenDrag:
		# pan when none of the points are currently being manipulated
		if not Nodes.any_pressed():
			camera.offset -= Camera.unproject_vector(event.relative)

func _on_clear_pressed() -> void:
	for child in path_renderer.get_nodes():
		child.queue_free()

func _on_range_slider_value_changed(value: float) -> void:
	path_renderer.set_additional_range(value)

func _on_steps_slider_value_changed(value: float) -> void:
	path_renderer.draw_steps = value
