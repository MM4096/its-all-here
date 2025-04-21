class_name PlayerAnimation
extends AnimatedSprite2D
## Class that handles player animation

## Particle reference for double jumping
@export var double_jump_particles: CPUParticles2D

## Reference to the [class Player]
var player_reference: Player

func _ready() -> void:
	player_reference = Player.instance
	player_reference.double_jumped.connect(_on_double_jump)

func _process(_delta: float) -> void:
	if player_reference.lock_player_movement:
		return

	self.visible = not player_reference.is_in_death_scene

	var player_velocity: Vector2 = player_reference.velocity

	self.scale.y = sign(player_reference.gravity_direction) * 8

	var horizontal: float = Input.get_axis("move_left", "move_right")
	if horizontal != 0:
		self.scale.x = sign(horizontal) * 8

	if player_velocity.distance_squared_to(Vector2.ZERO) < 10:
		self.animation = "idle"
	elif player_velocity.x != 0 and player_velocity.y == 0:
		self.animation = "walk"
	elif player_velocity.y < 50:
		self.animation = "jump"
	elif player_velocity.y > 50:
		self.animation = "fall"

func _on_double_jump():
	double_jump_particles.emitting = true
