class_name Save
extends Node
## Save system

## The SECRET PASSWORD!
const _ENCRYPT_PASS: StringName = &"thisisapasswordthatwasusedtoencrypt"

## [ConfigFile] that stores the save information
var save_file: ConfigFile = ConfigFile.new()

## The path to save the data at
var save_path: StringName = &"user://save.dat"

## Loads the save data into [member Save.save_file]
func load_save_file() -> ConfigFile:
	save_file.load_encrypted_pass(save_path, _ENCRYPT_PASS)
	return save_file

## Loads the save data[br]
## 	Places the player at [code][player]:[position][/code][br]
## 	Sets collected items to [code][player]:[items][/code]
func load_objects() -> void:
	load_save_file()
	if Player.instance == null:
		print("Player instance is null!")
		return
	if !save_file.has_section("player"):
		print("Save file doesn't have a section named [player]")
		return
	Player.instance.respawn_location = save_file.get_value("player", "position")
	Player.instance.gravity_direction = save_file.get_value("player", "gravity_direction")
	Player.instance.set_player_position(save_file.get_value("player", "position"))

	Player.instance.death_count = save_file.get_value("other info", "deaths", 0)

	ItemHandler.instance.set_collected_items(save_file.get_value("player", "items"))

	GameTimer.time += save_file.get_value("other info", "time", 0)
	GameTimer.is_active = not save_file.get_value("other info", "completed", false)

## Saves information to the file
func save_data() -> void:
	if Player.instance == null:
		return
	save_file.set_value("player", "position", Player.instance.respawn_location)

	save_file.set_value("player", "gravity_direction", Player.instance.gravity_direction)

	save_file.set_value("player", "items", ItemHandler.instance.collected_items)

	save_file.set_value("other info", "time", GameTimer.time)
	save_file.set_value("other info", "deaths", Player.instance.death_count)

	save_file.save_encrypted_pass(save_path, _ENCRYPT_PASS)

func finished_game() -> void:
	GameTimer.is_active = false
	save_file.set_value("other info", "completed", true)

func is_completed() -> bool:
	return save_file.get_value("other info", "completed", false)

func has_save() -> bool:
	return FileAccess.file_exists(save_path)
