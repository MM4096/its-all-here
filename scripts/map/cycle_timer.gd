class_name CycleTimer
extends Node
## Class to handle the cycling blocks

static var cycle_time: float = 1

var current_countdown: float = 0
var current_index: int = 1

func _process(delta: float) -> void:
	if (PauseMenu.is_paused): return

	current_countdown -= delta
	if current_countdown < 0:
		current_countdown = cycle_time
		if current_index == 1:
			current_index = 2
		else:
			current_index = 1
		MapHelper.instance.set_current_enabled_cycle(current_index)
