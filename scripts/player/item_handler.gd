class_name ItemHandler
extends Node2D
## Class to handle any items

## Emits when an item is collected, with the item's id
signal on_item_collected(item: String)

static var instance: ItemHandler

## A list of collected items
var collected_items: Array[String] = []

func _init() -> void:
	instance = self

func item_collected(item: String) -> void:
	collected_items.append(item)
	if item.begins_with("enable-blocks-"):
		var block: int = int(item.replace("enable-blocks-", ""))
		MapHelper.instance.toggle_appearing_layer(block, true)
	elif item == "alt-map":
		MapHelper.instance.set_alt_blocks_enabled(true)
		AltWarpDoors.instance.toggle_alt_doors(true)
	elif item == "fall damage":
		Player.instance.can_die_from_fall = true
	on_item_collected.emit(item)

## Sets the collected items
func set_collected_items(items: Array[String]) -> void:
	for i in items:
		item_collected(i)
