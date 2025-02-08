class_name PlayerDeathParticles
extends Node2D

static var instance: PlayerDeathParticles
var white_texture = preload("res://images/white.png")

func _init() -> void:
	instance = self

func create_particles(number: int = 48) -> void:
	for i in number:
		var color = Color.WHITE if randi_range(0, 1) == 1 else Color.BLACK
		var this_body: RigidBody2D = _create_item(color)
		#this_body.linear_velocity = Vector2(randf_range(-, 5), randf_range(-5, 5))
		this_body.global_position += Vector2(randi_range(-24, 24), randi_range(-48, 48))
		self.add_child(this_body)

func delete_all_particles() -> void:
	for i in self.get_children():
		i.queue_free()

func _create_item(color: Color = Color.WHITE) -> RigidBody2D:
	var body = RigidBody2D.new()

	body.collision_layer = 16
	body.collision_mask = 25

	var sprite = Sprite2D.new()
	sprite.texture = white_texture.duplicate()
	sprite.scale = Vector2.ONE * 0.25
	sprite.modulate = color

	var collision_shape = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = Vector2(8, 8)
	collision_shape.shape = rect

	body.add_child(sprite)
	body.add_child(collision_shape)

	return body
