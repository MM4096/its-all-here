@tool
class_name MenuDoor
extends Area2D
## WarpDoor that is designed specifically for the menu

## Node to teleport the player to
@export var teleport_to: Node2D
## Color of the door
@export var door_color: Color = Color.WHITE:
	set(color):
		door_color = color
		if Engine.is_editor_hint():
			if get_node_or_null("Sprite2D") is Sprite2D:
				get_node_or_null("Sprite2D").self_modulate = color

func _ready() -> void:
	if Engine.is_editor_hint():
		pass
	else:
		self.body_entered.connect(_body_entered)
		if get_node_or_null("Sprite2D") is Sprite2D:
			get_node_or_null("Sprite2D").self_modulate = door_color


func _body_entered(body: Node) -> void:
	if Engine.is_editor_hint():
		return
	if body is Player:
		if teleport_to == null:
			return
		body.set_player_position(teleport_to.global_position)
