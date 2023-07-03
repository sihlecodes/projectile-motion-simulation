extends Node

class Milestone:
	var completed: bool = false
	var instruction: String
	var action: String
	var next: Milestone

	func _init(action: String, instruction: String):
		self.action = action
		self.instruction = instruction

	func is_action(action: String) -> bool:
		return self.action == action

	func complete():
		completed = true

var current_milestone: Milestone

signal milestone_completed

func _ready():
	var move = Milestone.new("move", "you can drag on nodes to move them around.")
	var delete = Milestone.new("delete", "you can press shift and click on nodes to delete them.")
	var create = Milestone.new("create", "you can press contorl and drag from the center node to create new nodes.")

	move.next = delete
	delete.next = create

	current_milestone = move

func complete_milestone(action: String):
	if current_milestone.is_action(action):
		current_milestone.complete()
		current_milestone = current_milestone.next
		milestone_completed.emit()
