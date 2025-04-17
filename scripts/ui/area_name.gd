class_name AreaName
extends Label
## Label to show the text of the current area

static var instance: AreaName

var label_text: String:
	set(value):
		label_text = value
		self.text = value

var is_currently_alt_area: bool = false:
	set(value):
		is_currently_alt_area = value
		self.modulate = Color(0, 1, 1) if is_currently_alt_area else Color.WHITE

func _init() -> void:
	instance = self
