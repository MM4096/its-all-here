class_name GameTimer
extends Node

static var instance: GameTimer

static var time: float = 0
static var is_active: bool = true

func _init() -> void:
	instance = self


func _process(delta: float) -> void:
	if is_active:
		time += delta
