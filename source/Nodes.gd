extends Node

func get_path_nodes() -> Array:
	return get_tree().get_nodes_in_group("nodes")

func count() -> int:
	return get_path_nodes().size()

func do(fn: Callable) -> void:
	for node in get_path_nodes():
		if node is BaseNode:
			fn.call(node)

func any_pressed() -> bool:
	for node in get_path_nodes():
		if node is BaseNode:
			if node.pressed:
				return true
	return false

func disable_all() -> void:
	do(func(node): node.disable())

func enable_all() -> void:
	do(func(node): node.enable())

func disable_all_except(node: BaseNode) -> void:
	disable_all()
	node.enable()
