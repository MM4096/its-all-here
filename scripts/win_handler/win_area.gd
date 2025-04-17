class_name WinArea
extends Node
## Class to handle winning

## Area that triggers the win scene when the player enters
@export var player_area: Area2D
## Hit label
@export var hit_label: Label
## Timer Label
@export var timer_label: Label


func _ready() -> void:
	timer_label.text = ""
	player_area.body_entered.connect(_player_entered)

func _process(_delta: float) -> void:
	if SaveSystem.is_completed():
		hit_label.visible = false

		var is_hard_mode: bool = ItemHandler.instance.collected_items.has("hard-mode")
		var is_alt_map: bool = ItemHandler.instance.collected_items.has("alt-map")

		var final_time: float = GameTimer.time
		var temp_time: float = 0
		var hours: int = floori(final_time / 3600)
		temp_time = fmod(final_time, 3600)
		var minutes: int = floori(temp_time / 60)
		temp_time = fmod(temp_time, 60)
		var seconds: float = roundi(temp_time * 1000.0) / 1000

		var time_display: String = "%sh,%smin,%ssec" % [hours, minutes, seconds]

		var extra_text: String = ""
		if is_hard_mode:
			extra_text = "Hard Mode Completed!\n"
		if is_alt_map:
			extra_text += "Map Remix Completed!\n\n(I didn't think you could do it)"

		timer_label.text = "You have completed the game!\nYour time was %s\nYou died a total of %s times\n\n%s" % [time_display, Player.instance.death_count, extra_text]

func _player_entered(_body: Node2D) -> void:
	SaveSystem.finished_game()
