class_name CycleTimerArea
extends AreaMethod
## Changes [member CycleTimer.cycle_time] on enter

## The time to change it to
@export var cycle_timer: float

func _body_entered(_body: Node2D, _sender: TriggerArea) -> void:
	CycleTimer.cycle_time = cycle_timer
