@tool
class_name Checkpoint
extends Area2D
## A checkpoint that the player respawns at after dying.[br]
## Also, saves the game when the player enters

## The scale of the [CollisionShape2D]
@export var collision_size: Vector2 = Vector2.ONE:
	set(value):
		collision_size = value
		if get_node_or_null(^"CollisionShape2D") != null:
			get_node_or_null(^"CollisionShape2D").scale = value

## The offset of the [CollisionShape2D]
@export var collision_offset: Vector2 = Vector2.ZERO:
	set(value):
		collision_offset = value
		if get_node_or_null(^"CollisionShape2D") != null:
			get_node_or_null(^"CollisionShape2D").position = value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Engine.is_editor_hint():
		self.body_entered.connect(_on_body_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# TODO: Add "shine" when player enters

func _on_body_entered(body: Node2D):
	if Engine.is_editor_hint(): return
	if body is Player:
		Player.respawn_location = self.global_position
		Player.instance.saved_gravity_direction = Player.instance.gravity_direction
	SaveSystem.save_data()
	get_node_or_null(^"player particles").emitting = true
