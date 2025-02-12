class_name QuitGameArea
extends AreaMethod
## Quits the game

## Delay (seconds)
@export var delay: float = 0.5

func _body_entered(_body: Node2D, _sender: TriggerArea) -> void:
	if _body is Player:
		_body.do_death()
		await _sender.get_tree().create_timer(delay).timeout
		_sender.get_tree().quit()
