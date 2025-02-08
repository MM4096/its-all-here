extends Node2D

@export var player_reference: Player

## Max distance to go forwards by
@export var forwards_position_max: float = 50
## How much to move to target per second
@export var smooth_speed: float = 10
## The curve of how far the target should be. The distance should be the y-axis.
@export var distance_to_speed_curve: Curve

func _ready() -> void:
	if not get_tree().debug_collisions_hint:
		self.visible = false

func _process(delta: float) -> void:
	var target_position: Vector2 = Vector2.ZERO
	#if abs(player_reference.velocity.x) < 300:
		#target_position = 0
	#else:
	target_position = Vector2(distance_to_speed_curve.sample(abs(player_reference.velocity.x) / abs(player_reference.max_speed)) * forwards_position_max * sign(player_reference.velocity.x),
								player_reference.velocity.y / 5)

	var speed_bonus: float = 2 if sign(target_position.x) != sign(self.position.x) else 1
	self.position.x = move_toward(self.position.x, target_position.x, 100 * delta * speed_bonus)
	self.position.y = move_toward(self.position.y, target_position.y, 50 * delta)
