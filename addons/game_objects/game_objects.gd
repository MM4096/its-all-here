@tool
extends EditorPlugin


func _enter_tree() -> void:
	get_tree().node_added.connect(on_node_added)


func _exit_tree() -> void:
	get_tree().node_added.disconnect(on_node_added)

func on_node_added(node: Node):
	if node.get_child_count(true) > 0: return

	if node is AreaNameTrigger:
		var shape: CollisionShape2D = CollisionShape2D.new()
		node.add_child(shape)
		shape.owner = EditorInterface.get_edited_scene_root()
		shape.name = "CollisionShape2D"
		shape.shape = RectangleShape2D.new()
		shape.shape.size = Vector2(500, 500)
		shape.debug_color = Color("#de00d800")
	elif node is TriggerArea:
		node.set_collision_layer_value(1, false)
		node.set_collision_layer_value(3, true)

		node.set_collision_mask_value(1, false)
		node.set_collision_mask_value(2, true)

		var shape: CollisionShape2D = CollisionShape2D.new()
		node.add_child(shape)
		shape.owner = EditorInterface.get_edited_scene_root()
		shape.name = "CollisionShape2D"
		shape.shape = RectangleShape2D.new()
		shape.shape.size = Vector2(500, 500)
		shape.debug_color = Color("#aaaa0000")
	elif node is WarpDoorManager:
		var warp_door_reference: PackedScene = load("res://scenes/game/warp_door.tscn")
		var in_door = warp_door_reference.instantiate()
		if in_door is not WarpDoor:
			printerr("Given warp door reference was not a [WarpDoor]!")
			return

		node.add_child(in_door)
		in_door.owner = EditorInterface.get_edited_scene_root()
		in_door.name = "In"
		var out_door = warp_door_reference.instantiate()
		node.add_child(out_door)
		out_door.owner = EditorInterface.get_edited_scene_root()
		out_door.name = "Out"
		node.in_door = in_door
		node.out_door = out_door
		await get_tree().process_frame
		node.debug_color_of_door = Color(randf(), randf(), randf(), 0.5)
