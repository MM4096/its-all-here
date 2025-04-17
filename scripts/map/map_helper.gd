class_name MapHelper
extends Node2D
## Class to set collision layers for Tiled's imported tilemap

static var instance: MapHelper

@export var map: Node2D
@export var ground_layer_name: StringName
@export var death_layer_name: StringName
@export_group("Other")
@export var alt_text_node: Node2D

func _init() -> void:
	instance = self

func _ready() -> void:
	alt_text_node.visible = false
	for i in alt_text_node.get_children():
		i.visible = false
	for i in map.get_children():
		if i is TileMapLayer:
			if i.name.contains(ground_layer_name):
				i.tile_set = i.tile_set.duplicate(true)
				i.tile_set.set_physics_layer_collision_layer(0, 1)
			elif i.name.contains(death_layer_name):
				i.tile_set = i.tile_set.duplicate(true)
				i.tile_set.set_physics_layer_collision_layer(0, 8)
		elif i is Node2D:
			for j in i.get_children():
				if j is TileMapLayer:
					j.tile_set = j.tile_set.duplicate(true)
					if j.name == "visible" or j.name == "invisible":
						j.tile_set.set_physics_layer_collision_layer(0, 1)
					elif j.name == "cycle1" or j.name == "cycle2":
						j.tile_set.set_physics_layer_collision_layer(0, 1)
					else:
						j.tile_set.set_physics_layer_collision_layer(0, 0)

					if i.name == "appearing-6" and j.name == "visible":
						j.tile_set.set_physics_layer_collision_layer(0, 32)

	toggle_appearing_layer(1, false)
	toggle_appearing_layer(2, false)
	toggle_appearing_layer(3, false)
	toggle_appearing_layer(4, false)
	toggle_appearing_layer(5, false)
	toggle_appearing_layer(6, false)

	set_alt_blocks_enabled(false)

## Toggles [param layer_id] to [param shown]
func toggle_appearing_layer(layer_id: int, shown: bool = true) -> void:
	for i in map.get_children(true):
		if i.name == "appearing-%s" % layer_id:
			for j in i.get_children(true):
				if j is TileMapLayer:
					if j.name == "invisible":
						j.visible = !shown
						j.collision_enabled = !shown
					elif j.name == "visible":
						j.visible = shown
						j.collision_enabled = shown

## Set which "cycle" is currently enabled[br]
##[param cycle] can be [code]1[/code] or [code]2[/code]
func set_current_enabled_cycle(cycle: int) -> void:
	for i in map.get_children(true):
		if i.name == "timer blocks":
			for j in i.get_children(true):
				if j is TileMapLayer:
					if j.name == "cycle1":
						j.visible = cycle == 1
						j.collision_enabled = cycle == 1
					if j.name == "cycle2":
						j.visible = cycle == 2
						j.collision_enabled = cycle == 2

## Enable/disable the alternate blocks
func set_alt_blocks_enabled(enable: bool = false) -> void:
	alt_text_node.visible = enable
	for i in alt_text_node.get_children():
		i.visible = enable

	for i in map.get_children(true):
		if i.name.contains("_alt"):
			if i is TileMapLayer:
				if i.name.contains("map"):
					i.visible = enable
				i.collision_enabled = enable
