@tool
extends Node

func _ready() -> void:
	reset_areas_recursive(EditorInterface.get_edited_scene_root())
	print("Done!")

func reset_areas_recursive(parent: Node):
	for i in parent.get_children(true):
		if i is AreaNameTrigger:
			if i.alt_area_name == "<null>" or i.alt_area_name == null:
				i.alt_area_name = ""
		else:
			reset_areas_recursive(i)
