@tool
class_name WarpDoorManager
extends Node2D
## Controller for [WarpDoor]s

## If the doors are 2 way, either side can be entered
@export var doors_are_two_way: bool = false
@export_group("Config")
## The door that is entered
@export var in_door: WarpDoor
## The door that is exited
@export var out_door: WarpDoor
## THe debug color of both doors
@export var debug_color_of_door: Color:
	set(color):
		debug_color_of_door = color
		if Engine.is_editor_hint():
			if self == null or in_door == null or out_door == null:
				return
			debug_color_of_door.a = 0.5
			for i in in_door.get_children():
				if i is CollisionShape2D:
					i.debug_color = debug_color_of_door
			for i in out_door.get_children():
				if i is CollisionShape2D:
					i.debug_color = debug_color_of_door

func _enter_tree() -> void:
	if Engine.is_editor_hint():
		if self == null or in_door == null or out_door == null:
			return
		debug_color_of_door.a = 0.5
		for i in in_door.get_children():
			if i is CollisionShape2D:
				i.debug_color = debug_color_of_door
		for i in out_door.get_children():
			if i is CollisionShape2D:
				i.debug_color = debug_color_of_door

func _ready() -> void:
	if Engine.is_editor_hint():
		_enter_tree()
		return

	for i in in_door.get_children():
		if i is CollisionShape2D:
			i.debug_color = Color(1, 1, 1, 0)
	for i in out_door.get_children():
		if i is CollisionShape2D:
			i.debug_color = Color(1, 1, 1, 0)

	in_door.parent = self
	in_door.is_in_portal = 1 if not doors_are_two_way else -1
	in_door.enabled = false

	out_door.parent = self
	out_door.is_in_portal = 0 if not doors_are_two_way else -1
	out_door.enabled = false

	ItemHandler.instance.on_item_collected.connect(_on_item_collected)

func _on_item_collected(item: String) -> void:
	if item == "warp_orb":
		in_door.enabled = true
		out_door.enabled = true

func _teleport_player(object: Node2D, sender: WarpDoor) -> void:
	if not object is Player:
		return

	if sender == in_door:
		Player.instance.set_player_position(out_door.global_position)
		Player.instance.velocity = Vector2.ZERO
	elif doors_are_two_way:
		var final_position: Vector2 = out_door.global_position
		if sender == out_door:
			final_position = in_door.global_position
		Player.instance.set_player_position(final_position)
		Player.instance.velocity = Vector2.ZERO

	in_door.require_refresh = true
	out_door.require_refresh = true

#region draw calls
var is_drawing: bool = false
func _draw() -> void:
	if is_drawing:

		# triangle
		var points: Array[Vector2] = []
		# in_door triangle points
		points.append((in_door.position.normalized() * 10).rotated(PI / 2) + in_door.position)
		points.append((in_door.position.normalized() * 10).rotated(-PI / 2) + in_door.position)
		points.append(out_door.position)
		self.draw_colored_polygon(points, Color.CYAN)

		#self.draw_polyline(points, Color.RED)
		self.draw_polyline_colors([in_door.position, out_door.position], [Color.RED, Color.GREEN], -1)
#endregion
