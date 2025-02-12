class_name Player
extends CharacterBody2D
## The player character

static var instance: Player

@export_group("Movement")
## Fall speed, keep negative
@export var gravity: float = -900
## The maximum horizontal speed
@export var max_speed: float = 300
## Jump force
@export var jump_velocity: float = 400
## Acceleration speed, the player's speed increases by this much per second
@export var acceleration: float = 400
## Horizontal deacceleration speed, after the player stops moving
@export var deaccel_speed: float = 500
## The speed that the player slows down vertically when [jump] isn't held down
@export var jump_deaccel_speed: float = 100
## The max y-velocity before death on impact
@export var kill_velocity: float = 1000
@export_group("Ease of Life Features")
## The amount of time to allow the player to jump after leaving the ground
@export var coyote_time: float = 0.1
## The amount of time that a player could press [jump] before touching the ground
@export var cached_jump_time: float = 0.1
@export_group("Collisions")
## The death overlap box
@export var death_box: Area2D
## The collision shape of the death area
@export var death_collision_shape: CollisionShape2D
## The collision shape of the player
@export var collision_shape: CollisionShape2D
## Collision box for gravity areas
@export var gravity_box: Area2D
@export_group("Misc")
## Tracker that the camera follows
@export var tracker: Node2D
## Velocity to kill the player at (fall damage velocity)
@export var fall_velocity: float = 1600
@export_group("Double Jump")
## If the item [code]double_jump[/code] is obtained, this is the velocity of the second jump
@export var double_jump_velocity: float = 300
## After double-jumping, this is the max fall velocity before death
@export var double_jump_max_fall_velocity: float = 300
@export_group("Wall Jump")
## The left area for walljumping
@export var left_walljump_area: Area2D
## The right area for walljumping
@export var right_walljump_area: Area2D
## The vertical velocity gained after walljumping
@export var walljump_vertical_velocity: float = -1100
## The (opposite) horizontal velocity after walljumping
@export var walljump_horizontal_velocity: float = 300
## The max slide speed
@export var slide_speed: float = 100

@export_group("Raycasts")
@export_subgroup("Ground")
## Left Raycast for ground
@export var raycast_ground_left: RayCast2D
## Right Raycast for ground
@export var raycast_ground_right: RayCast2D
## Up Raycast for ground
@export var raycast_ground_up: RayCast2D
## Down Raycast for ground
@export var raycast_ground_down: RayCast2D

## If set to [code]true[/code], the player can die of fall damage
var can_die_from_fall: bool = false

## Current countdown for coyote jumping
var coyote_timer: float = 0
## Current countdown for caching jumps
var cached_jump_timer: float = 0
## The velocity of the previous frame, set before [method CharacterBody2D.move_and_slide]
var previous_frame_velocity: Vector2 = Vector2.ZERO

## The last y-velocity. See [member Player.previous_frame_velocity] for details on how this is set
var last_movement_velocity_y: float = 0

var _has_double_jumped: bool = false

## Respawn location of the player
static var respawn_location: Vector2 = Vector2.ZERO

## If set to [code]true[/code], the player will withstand fall damage - once
var is_currently_floating: bool = false
## Gravity direction. [code]1[/code] is default; [code]-1[/code] is flipped
var gravity_direction: int = 1
## Gravity direction when checkpoint was hit
var saved_gravity_direction: int = 1

## The starting y-position of a jump. Used for calculating fall damage
var jump_start_y_position: float = 0
## Whether to use [code]velocity.y[/code] or [member Player.jump_start_y_position] for death calculations
var use_fall_velocity_for_death_calculation: bool = false

## Is the user currently in the death scene?
var is_in_death_scene: bool = false

## Number of deaths the player has sufferred
var death_count: int = 0

func _init() -> void:
	instance = self

func _ready() -> void:
	respawn_location = self.global_position

func _physics_process(delta: float) -> void:
	if is_in_death_scene:
		return

	use_fall_velocity_for_death_calculation = ItemHandler.instance.collected_items.has("hard-mode")

	self.up_direction.y = -gravity_direction
	#region movement
	coyote_timer -= delta
	cached_jump_timer -= delta


	if is_on_floor():
		coyote_timer = coyote_time
		var kill_y_velocity: float = double_jump_max_fall_velocity if _has_double_jumped else kill_velocity
		if not can_die_from_fall:
			kill_y_velocity = INF
			jump_start_y_position = self.global_position.y


		if use_fall_velocity_for_death_calculation:
			if abs(last_movement_velocity_y) > abs(kill_y_velocity):
				if is_currently_floating:
					is_currently_floating = false
				else:
					do_death()
		else:
			var fall_distance: float = (self.global_position.y - jump_start_y_position) * (gravity_direction)
			var fall_blocks: float = fall_distance / 64
			if fall_blocks > 4.5:
				if is_currently_floating:
					is_currently_floating = false
				else:
					do_death()

		last_movement_velocity_y = 0
		_has_double_jumped = false
		is_currently_floating = false
		jump_start_y_position = self.global_position.y
	else:
		self.velocity.y += gravity * delta * gravity_direction

		if ItemHandler.instance.collected_items.has("wall_jump"):
			if (_does_area_have_bodies(left_walljump_area) and Input.is_action_pressed("move_left")) or \
				_does_area_have_bodies(right_walljump_area) and Input.is_action_pressed("move_right"):
				jump_start_y_position = self.global_position.y
				_has_double_jumped = false
				if gravity_direction == 1:
					self.velocity.y = clamp(self.velocity.y, -INF, slide_speed)
				else:
					self.velocity.y = clamp(self.velocity.y, -slide_speed, INF)

	var horizontal: int = roundi(Input.get_axis("move_left", "move_right"))
	if horizontal != 0:
		var bonus_acceleration: float = 2 if sign(horizontal) != sign(self.velocity.x) else 1
		self.velocity.x += horizontal * acceleration * delta * bonus_acceleration
	else:
		self.velocity.x -= sign(self.velocity.x) * deaccel_speed * delta
		if abs(self.velocity.x) < 100:
			self.velocity.x = 0
	self.velocity.x = clamp(self.velocity.x, -max_speed, max_speed)

	if (is_on_floor() or coyote_timer > 0) and (Input.is_action_just_pressed("move_up") or cached_jump_timer > 0):
		self.velocity.y = jump_velocity * gravity_direction
		coyote_timer = 0
		cached_jump_timer = 0
		jump_start_y_position = self.global_position.y
	elif Input.is_action_just_pressed("move_up") and ItemHandler.instance.collected_items.has("wall_jump") \
		and (_does_area_have_bodies(right_walljump_area) or _does_area_have_bodies(left_walljump_area)):
		if _does_area_have_bodies(left_walljump_area):
			# walljump right
			self.velocity.y = walljump_vertical_velocity * gravity_direction
			self.velocity.x = walljump_horizontal_velocity
			_has_double_jumped = false
		elif _does_area_have_bodies(right_walljump_area):
			# walljump left
			self.velocity.y = walljump_vertical_velocity * gravity_direction
			self.velocity.x = -walljump_horizontal_velocity
			_has_double_jumped = false
		jump_start_y_position = self.global_position.y
	elif Input.is_action_just_pressed("move_up") and not _has_double_jumped and \
		ItemHandler.instance.collected_items.has("double_jump"):
		_has_double_jumped = true
		self.velocity.y = double_jump_velocity * gravity_direction
		jump_start_y_position = self.global_position.y

	if Input.is_action_just_pressed("move_up"):
		cached_jump_timer = cached_jump_time

	if !Input.is_action_pressed("move_up") and  \
		((self.velocity.y < 0 and gravity_direction == 1) or (self.velocity.y > 0 and gravity_direction == 0)):
		if gravity_direction == 1:
			self.velocity.y = move_toward(self.velocity.y, 0, jump_deaccel_speed * delta)
		else:
			self.velocity.y = move_toward(self.velocity.y, 0, -jump_deaccel_speed * delta)

	previous_frame_velocity = self.velocity
	if self.velocity.y != 0:
		last_movement_velocity_y = self.velocity.y


	self.velocity.y = clampf(self.velocity.y, -5000, 5000)

	move_and_slide()
	self.global_position = PixelPerfect.to_pixel_perfect(self.global_position)
	#endregion

	if len(death_box.get_overlapping_areas()) > 0 or len(death_box.get_overlapping_bodies()) > 0:
		do_death()

## Function to kill the player
func do_death() -> void:
	death_count += 1
	self.velocity = Vector2.ZERO

	is_in_death_scene = true
	PlayerDeathParticles.instance.create_particles()
	await get_tree().create_timer(3).timeout
	PlayerDeathParticles.instance.delete_all_particles()
	is_in_death_scene = false

	gravity_direction = saved_gravity_direction

	set_player_position(respawn_location)

## Places a player at a position after enabling/disabling the collision shape as per [url=https://github.com/godotengine/godot/issues/83835]this issue[/url][br]
## If [param instant] is set to [code]false[/code], the player will get moved to the new position over the course of [param time] seconds.
func set_player_position(location: Vector2, instant: bool = true, time: float = 0):
	collision_shape.set_deferred("disabled", true)
	death_collision_shape.set_deferred("disabled", true)
	await get_tree().physics_frame
	self.global_position = location
	jump_start_y_position = self.global_position.y
	self.velocity = Vector2.ZERO
	await get_tree().physics_frame
	collision_shape.set_deferred("disabled", false)
	death_collision_shape.set_deferred("disabled", false)

func _does_area_have_bodies(area: Area2D) -> bool:
	if len(area.get_overlapping_areas()) > 0:
		return true
	elif len(area.get_overlapping_bodies()) > 0:
		return true
	return false
