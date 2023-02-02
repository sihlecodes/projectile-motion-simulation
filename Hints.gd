extends Object

class Milestone:
	var completed: bool = false
	var instruction: String
	var next: Milestone

	func _init(instruction: String) -> void:
		self.instruction = instruction

var milestones: = {}

func _init() -> void:
	var _move = Milestone.new("you can click & drag on nodes to move them around.")
	var _delete = Milestone.new("you can press shift & click on nodes to delete them.")
	var _add = Milestone.new("you can press contorl, click & drag from the center node to create nodes.")

	_move.next = _delete
	_delete.next = _add

	milestones.add = _add
	milestones.delete = _delete
	milestones.move = _move
