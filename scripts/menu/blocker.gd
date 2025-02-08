class_name MenuBlock
extends StaticBody2D
## A solid block used in the menu

## Whether the block should have collision
func set_collision_status(enabled: bool) -> void:
	for i in self.get_children():
		if i is CollisionShape2D:
			i.set_deferred("disabled", !enabled)
	self.visible = enabled
