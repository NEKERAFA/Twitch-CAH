extends PanelContainer


@export var content = "Card Content.":
	set = _set_content


@onready var _content_lbl: Label = $Content


func _ready():
	_content_lbl.text = content


func _set_content(value):
	content = value

	if _content_lbl:
		_content_lbl.text = content
