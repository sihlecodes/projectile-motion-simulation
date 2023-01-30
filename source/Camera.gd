extends Node

@onready var camera: = get_viewport().get_camera_2d()

func unproject_vector(vector: Vector2) -> Vector2:
	return vector / camera.zoom

func unproject_scalar(size: float) -> float:
	return size / camera.zoom.x
