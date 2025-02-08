class_name DeathOrbStatusArea
extends AreaMethod
## Area that sets the [member DeathOrb.enabled] field, on player enter

## The path to the [DeathOrb] to set status
@export var death_orb_to_move: NodePath
## Whether that orb should be enabled
@export var enabled: bool = true
## If set to [code]true[/code], the orb will be disabled on body exited
@export var disable_on_exit: bool = false
## Sets [member DeathOrb.speed]. If set to [code]-1[/code], the orb keeps its current speed
@export var speed: float = -1

func _body_entered(body: Node2D, sender: TriggerArea):
	if body is Player:
		var node: Node = sender.get_node_or_null(death_orb_to_move)
		if node == null:
			return
		if node is DeathOrb:
			node.set_enabled(enabled)

			if speed >= 0:
				node.speed = speed

func _body_exited(body: Node2D, sender: TriggerArea):
	if body is Player:
		var node: Node = sender.get_node_or_null(death_orb_to_move)
		if node == null:
			return
		if node is DeathOrb and disable_on_exit:
			node.set_enabled(false)
