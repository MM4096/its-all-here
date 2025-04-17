class_name PlayerGravityBox
extends Area2D
## Class that handles gravity pad interaction


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.area_entered.connect(_on_body_entered)
	self.body_entered.connect(_on_body_entered)


func _on_body_entered(_body: Node):
	if Player.instance.is_currently_floating:
		return

	Player.instance.gravity_direction = -Player.instance.gravity_direction
	Player.instance.is_currently_floating = true
