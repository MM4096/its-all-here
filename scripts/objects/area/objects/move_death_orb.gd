class_name MoveDeathOrbArea
extends AreaMethod
## Area that sets a [DeathOrb]'s position

## The [DeathOrb] to move
@export var death_orb_to_move: NodePath
## The index of a position to move the [DeathOrb] to
@export var index: int

func _body_entered(body: Node2D, sender: TriggerArea):
	if body is Player:
		var node: Node = sender.get_node_or_null(death_orb_to_move)
		if node == null:
			return
		if node is DeathOrb:
			node.go_to_point(index)
