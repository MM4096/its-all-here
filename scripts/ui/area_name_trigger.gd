@tool
class_name AreaNameTrigger
extends Area2D
## Sets the [AreaName]

## Name of this area
@export var area_name: String = "":
	set(value):
		area_name = value
		if Engine.is_editor_hint():
			self.name = area_name
## Name to display when the Alt-Map mode is selected
@export var alt_area_name: String = ""
## If set to [code]true[/code], the text is cleared if the current area text matches [member AreaNameTrigger.area_name]
@export var hide_name_on_leave: bool = true

var current_text: String = ""

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	self.set_collision_layer_value(1, false)
	self.set_collision_layer_value(3, true)

	self.set_collision_mask_value(1, false)
	self.set_collision_mask_value(2, true)

	self.body_entered.connect(_body_entered)
	if hide_name_on_leave:
		self.body_exited.connect(_body_exited)

func _body_entered(_body: Node2D) -> void:
	current_text = alt_area_name if alt_area_name != "" and ItemHandler.instance.collected_items.has("alt-map") else area_name
	if Engine.is_editor_hint():
		return
	AreaName.instance.label_text = current_text
	AreaName.instance.is_currently_alt_area = current_text == alt_area_name


func _body_exited(_body: Node2D) -> void:
	current_text = alt_area_name if alt_area_name != "" and ItemHandler.instance.collected_items.has("alt-map") else area_name
	if Engine.is_editor_hint():
		return
	if AreaName.instance.label_text == current_text:
		if AreaName.instance.label_text == current_text:
			AreaName.instance.label_text = ""
			AreaName.instance.is_currently_alt_area = current_text == alt_area_name
