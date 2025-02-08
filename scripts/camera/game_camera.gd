extends Camera2D

@export var track_target: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if track_target == null:
		track_target = Player.instance.tracker

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	self.global_position = track_target.global_position
