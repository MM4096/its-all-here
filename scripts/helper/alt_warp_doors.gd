class_name AltWarpDoors
extends Node

static var instance: AltWarpDoors

func _init() -> void:
	instance = self

func _ready() -> void:
	toggle_alt_doors(false)

func toggle_alt_doors(enable: bool) -> void:
	for i in self.get_children():
		if i is WarpDoorManager:
			i.disabled = not enable
