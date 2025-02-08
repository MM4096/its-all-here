@tool
extends Node

func _move_checkpoints() -> void:
	for i in _get_nodes_recursive(EditorInterface.get_edited_scene_root()):
		if i is Checkpoint:
			pass

func _get_nodes_recursive(root: Node, is_entrypoint: bool = true) -> Array[Node]:
	var nodes: Array[Node] = root.get_children()
	for i in nodes:
		nodes.append_array(_get_nodes_recursive(i, false))

	return nodes
