class_name PauseMenu
extends Node2D

@export var place_player_location: Node2D
@export var menu_location: Node2D

var is_paused: bool = false
var cached_player_velocity: Vector2 = Vector2.ZERO
var cached_player_position: Vector2 = Vector2.ZERO
var cached_start_y_position: float = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		is_paused = not is_paused

		if is_paused:
			var player_reference: Player = Player.instance
			cached_player_position = player_reference.global_position
			cached_player_velocity = player_reference.velocity
			cached_start_y_position = player_reference.jump_start_y_position

			player_reference.velocity = Vector2.ZERO
			player_reference.set_player_position(place_player_location.global_position)
		else:
			resume()

func _area_body_entered(body: Node2D, is_resume: bool) -> void:
	is_paused = false
	if is_resume:
		resume()
	else:
		menu()

func resume() -> void:
	var player_reference: Player = Player.instance
	await player_reference.set_player_position(cached_player_position)
	player_reference.velocity = cached_player_velocity
	player_reference.jump_start_y_position = cached_start_y_position

func menu() -> void:
	var player_reference: Player = Player.instance
	player_reference.set_player_position(menu_location.global_position)
	ItemHandler.instance.collected_items = []
