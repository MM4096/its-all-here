class_name QuitGameArea
extends AreaMethod
## Quits the game

## Delay (seconds)
@export var delay: float = 0.5

func _body_entered(_body: Node2D, _sender: TriggerArea) -> void:
	print("Here!")
	if _body is Player:
		await _sender.get_tree().create_timer(delay).timeout
		_sender.get_tree().quit()
