extends Node

func do(fn: Callable) -> void:
	for node in get_tree().get_nodes_in_group("points"):
		fn.call(node)
	
func disable() -> void:
	do(func(node): node.disable())

func enable() -> void:
	do(func(node): node.enable())
	
func disable_all_except(node: Point) -> void:
	disable()
	node.enable()
