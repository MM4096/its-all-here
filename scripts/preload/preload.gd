class_name Preload
extends Node

@export var loading_container: Node
@export_file("*.tscn") var game_scene_path: String
@export_group("Animation")
@export var animation_player: AnimationPlayer
@export var fps: int = 10

var anim_timer: float = 0
var anim_total_time: float = 0

func _ready() -> void:
	ResourceLoader.load_threaded_request(game_scene_path)
	await _do_wait()
	_after_main_loaded()


func _do_wait() -> void:
	while ResourceLoader.load_threaded_get_status(game_scene_path) != ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
		await get_tree().process_frame

	var loaded_game_scene = ResourceLoader.load_threaded_get(game_scene_path).instantiate()
	self.add_child(loaded_game_scene)
	await get_tree().process_frame

	Player.instance.lock_player_movement = true

	return

func _after_main_loaded() -> void:
	animation_player.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL
	animation_player.current_animation = "default"
	anim_total_time = animation_player.current_animation_length
	while anim_total_time > 0:
		await get_tree().process_frame
		var delta = self.get_process_delta_time()
		anim_timer += delta
		anim_total_time -= delta
		if anim_timer >= 1.0 / fps:
			anim_timer -= 1.0 / fps
			animation_player.advance(1.0 / fps)

	loading_container.queue_free()

	Player.instance.lock_player_movement = false
