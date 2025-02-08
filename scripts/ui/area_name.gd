class_name AreaName
extends Label
## Label to show the text of the current area

static var instance: AreaName

var label_text: String:
	set(value):
		label_text = value
		self.text = value

func _init() -> void:
	instance = self
