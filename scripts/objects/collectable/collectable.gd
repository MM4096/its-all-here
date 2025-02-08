@tool
class_name Collectable
extends Area2D
## Base class for a collectable

## UID of this item
@export var item_id: StringName
## The sprite that should be displayed for this item
@export var item_sprite: Texture2D:
	set(value):
		item_sprite = value
		sprite.scale = Vector2.ONE
		sprite.texture = value
		sprite.scale = Vector2.ONE * 64 / value.get_size()
## [class Sprite2D] reference
@export var sprite: Sprite2D


func _ready() -> void:
	if not Engine.is_editor_hint():
		self.body_entered.connect(_on_body_enterd)

func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	if ItemHandler.instance.collected_items.has(item_id):
		self.queue_free()

func _on_body_enterd(body: Node2D) -> void:
	if body is Player:
		ItemHandler.instance.item_collected(item_id)
		self.queue_free()
