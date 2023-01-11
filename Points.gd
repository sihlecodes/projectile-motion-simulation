extends Node

func do(fn: Callable) -> void:
	for node in get_tree().get_nodes_in_group("points"):
		if node is BasePoint:
			fn.call(node)

func all_enabled():
	for node in get_tree().get_nodes_in_group("points"):
		if node is BasePoint:
			if node.disabled:
				return false
	return true

func disable() -> void:
	do(func(node): node.disable())

func enable() -> void:
	do(func(node): node.enable())

func disable_all_except(node: BasePoint) -> void:
	disable()
	node.enable()
