class_name AltWarpDoors
extends Node

static var instance: AltWarpDoors

func _init() -> void:
	instance = self

func _ready() -> void:
	toggle_alt_doors(false)

func toggle_alt_doors(enable: bool, parent: Node2D = null) -> void:
	for i in (parent.get_children() if parent != null else self.get_children()):
		if i is WarpDoorManager:
			i.disabled = not enable
		else:
			for j in i.get_children():
				toggle_alt_doors(enable, j)
