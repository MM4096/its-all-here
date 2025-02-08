@tool
class_name DeathOrb
extends Area2D
## An orb that kills the player on contact

## The list of points for the orb to move between, relative to the orb's initial position
@export var points: Array[Vector2]:
	set(value):
		points = value
		if Engine.is_editor_hint():
			queue_redraw()
## The speed of the orb
@export var speed: float = 50
## The direction of the orb's travel[br]
## [code]Loop[/code] (0): From the last point, jumps back to the first point[br]
## [code]Ping-Pong[/code] (1): Goes forwards, then backwards at the last point
@export_enum("Loop:0", "Ping-Pong:1") var direction_of_travel: int
@export_group("Config")
## If the player is more than this far away, the orb will despawn.[br]
## Set to [code]-1[/code] to disable despawning
@export var despawn_distance: float = 2000
## If not [code]null[/code], this orb will despawn based on [member DeathOrb.despawn_linked_orb]'s [member DeathOrb.enabled] status
## instead of [member DeathOrb.despawn_distance]
@export var despawn_linked_orb: DeathOrb
## Is the orb enabled?[br]
## A disabled orb does not move, and still does collision
@export var enabled: bool = true
## If set to [code]true[/code], this orb will ignore [member DeathOrb.despawn_distance].[br]
## This is automatically set to [code]false[/code] when the orb is shown again by [method DeathOrb.set_enabled].
@export var disabled_from_function: bool = false
## Particles Reference
@export var particles: CPUParticles2D
## Collision shape reference
@export var collision_shape: CollisionShape2D

## The gradient of lines to draw
var line_gradient: Gradient = Gradient.new()

## The current moving direction of the orb
var direction: int = 1
## The current index that the orb is at
var current_index: int = 0
## Start position
var initial_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	if Engine.is_editor_hint():
		line_gradient.add_point(0.0 / 7, Color.RED)
		line_gradient.add_point(1.0 / 7, Color.ORANGE)
		line_gradient.add_point(2.0 / 7, Color.YELLOW)
		line_gradient.add_point(3.0 / 7, Color.GREEN)
		line_gradient.add_point(4.0 / 7, Color.BLUE)
		line_gradient.add_point(5.0 / 7, Color.INDIGO)
		line_gradient.add_point(6.0 / 7, Color.PURPLE)
		line_gradient.add_point(7.0 / 7, Color.RED)
	else:
		initial_position = self.global_position

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return


	if not disabled_from_function:
		var handled_despawn: bool = false
		if despawn_linked_orb != null:
			handled_despawn = true
			enabled = despawn_linked_orb.enabled
		if not handled_despawn:
			if despawn_distance > 0:
				if Player.instance.global_position.distance_squared_to(self.global_position) > pow(despawn_distance, 2):
					enabled = false
				else:
					enabled = true

	particles.emitting = enabled

	collision_shape.disabled = not enabled
	visible = enabled

	if !enabled: return

	var distance_to_travel: float = delta * speed
	var distance_until_next_point: float = self.global_position.distance_to(_get_next_point())
	while distance_to_travel > 0:
		if distance_until_next_point <= distance_to_travel:
			self.global_position = _get_next_point()
			current_index = _get_next_point_index()
			distance_to_travel -= distance_until_next_point

			distance_until_next_point = self.global_position.distance_to(_get_next_point())
		else:
			var direction_point: Vector2 = _get_next_point() - self.global_position
			direction_point = direction_point.limit_length(distance_to_travel)
			self.global_position += direction_point
			distance_to_travel = 0

func _draw() -> void:
	if !Engine.is_editor_hint(): return
	if len(points) == 0: return

	var temp_points: Array[Vector2] = points.duplicate(true)
	if direction_of_travel == 0:
		temp_points.append(temp_points[0])

	var color_of_points: Array[Color] = []

	for i in len(temp_points):
		color_of_points.append(line_gradient.sample(float(i) / len(temp_points) ))

	if len(temp_points) > 1:
		draw_polyline_colors(temp_points, color_of_points)

	for i in points:
		draw_circle(i, 2, Color.WHITE, true)

func _get_next_point() -> Vector2:
	return get_point_position(_get_next_point_index())

## Returns the global position of a point, based on [code]index[/code]
func get_point_position(index: int) -> Vector2:
	return points[index] * self.global_scale + initial_position

func _get_next_point_index() -> int:
	var next_point: int = 0
	if direction_of_travel == 1:
		if direction == -1 and current_index == 0:
			direction = 1
		elif direction == 1 and current_index == len(points) - 1:
			direction = -1
		next_point = current_index + direction
	elif direction_of_travel == 0:
		if current_index == len(points) - 1:
			next_point = 0
		else:
			next_point = current_index + 1
	return next_point

## Teleports the orb to the given index
func go_to_point(point: int) -> void:
	if point < 0:
		while point < 0:
			point = len(points) - abs(point)
	if point >= len(points) - 1:
		point = len(points) - 1

	current_index = point
	self.global_position = get_point_position(current_index)

## This function enables the orb
func set_enabled(_enabled: bool) -> void:
	enabled = _enabled
	for i in self.get_children():
		if i is CollisionShape2D:
			i.set_deferred("disabled", !enabled)
	self.visible = enabled
	disabled_from_function = !enabled
