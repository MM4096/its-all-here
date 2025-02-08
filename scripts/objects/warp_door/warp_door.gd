class_name WarpDoor
extends Area2D
## A door that teleports the player

## If set to [code]false[/code], no sprite will be shown
@export var use_sprite: bool = true

## IMPORTANT: DO NOT SET THIS VARIABLE, UNLESS FROM [ItemHandler]!
var enabled: bool:
	set(value):
		enabled = value
		if _shape != null:
			_shape.set_deferred("disabled", !enabled)
		if _animator != null:
			if value:
				var animation: String = "default"
				if is_in_portal == 0:
					animation = "out_player"
				elif is_in_portal == 1:
					animation = "in_player"
				elif is_in_portal == -1:
					animation = "both_player"
				_animator.animation = animation
			else:
				_animator.animation = &"default"

## The type of portal this is[br]
## [code]0[/code]: In Portal
## [code]1[/code]: Out Portal
## [code]2[/code]: Two-Way Portal
var is_in_portal: int = 0
## Whether the player needs to re-enter this portal to teleport this player again
var require_refresh: bool = false

var _animator: AnimatedSprite2D = null
var _shape: CollisionShape2D = null
## The [WarpDoorManager] that this door is a child of
var parent: WarpDoorManager = null

func _ready() -> void:
	for i in self.get_children():
		if i is AnimatedSprite2D:
			_animator = i
		elif i is CollisionShape2D:
			_shape = i

	await get_tree().process_frame
	if (not parent.doors_are_two_way) and is_in_portal == 0:
		pass
	else:
		self.body_entered.connect(_body_entered)
		self.body_exited.connect(_body_exited)

	_animator.visible = use_sprite


func _body_entered(body: Node2D) -> void:
	if require_refresh: return
	parent._teleport_player(body, self)

func _body_exited(_body: Node2D) -> void:
	require_refresh = false
