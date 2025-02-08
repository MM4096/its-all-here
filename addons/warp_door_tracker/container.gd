@tool
extends Control

var selected_option: int = -1

func _option_changed(option: int) -> void:
	selected_option = option
	_draw_lines()

func _refresh() -> void:
	_option_changed(selected_option)

func _get_all_nodes(parent: Node) -> Array[Node]:
	var ret: Array[Node] = []
	for i in parent.get_children():
		ret.append(i)
		ret.append_array(_get_all_nodes(i))
	return ret

func _draw_lines() -> void:
	if selected_option == 0:
		for i in _get_all_nodes(EditorInterface.get_edited_scene_root()):
			if i is WarpDoorManager:
				i.is_drawing = false
				i.queue_redraw()
	elif selected_option == 1:
		for i in _get_all_nodes(EditorInterface.get_edited_scene_root()):
			if i is WarpDoorManager:
				i.is_drawing = true
				i.queue_redraw()
