extends Node

func count() -> int:
	return get_tree().get_nodes_in_group("points").size()

func do(fn: Callable) -> void:
	for node in get_tree().get_nodes_in_group("points"):
		if node is BasePoint:
			fn.call(node)

func any_pressed() -> bool:
	for node in get_tree().get_nodes_in_group("points"):
		if node is BasePoint:
			if node.pressed:
				return true
	return false

func disable_all() -> void:
	do(func(node): node.disable())

func enable_all() -> void:
	do(func(node): node.enable())

func disable_all_except(node: BasePoint) -> void:
	disable_all()
	node.enable()
