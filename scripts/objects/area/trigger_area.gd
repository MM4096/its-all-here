class_name TriggerArea
extends Area2D
## Generic class for a trigger area, runs several [AreaMethod]s when a body enters

@export var methods: Array[AreaMethod]

func _ready() -> void:
	self.body_entered.connect(_body_entered)
	self.body_exited.connect(_body_exited)

func _body_entered(body: Node2D):
	for i in methods:
		i._body_entered(body, self)

func _body_exited(body: Node2D):
	for i in methods:
		i._body_exited(body, self)
