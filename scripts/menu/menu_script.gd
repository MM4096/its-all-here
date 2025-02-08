class_name MenuScript
extends Node
## Handles menu objects

## When this area is entered, everything updates
@export var area_reference: Area2D
@export_group("Blocks")
## Blocks "Load Game" option
@export var load_game_block: MenuBlock
@export_group("Areas")
## Area to load the game
@export var start_game_area: Area2D

func _ready() -> void:
	area_reference.body_entered.connect(_refresh)
	start_game_area.body_entered.connect(_start_game)

func _refresh(body: Node) -> void:
	if body is not Player:
		return
	load_game_block.set_collision_status(not SaveSystem.has_save())


func _start_game(body: Node) -> void:
	GameLoader.load_game()

func give_hard_items(body: Node2D) -> void:
	ItemHandler.instance.item_collected("hard-mode")
