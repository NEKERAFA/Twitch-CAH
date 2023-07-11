class_name MasterCard
extends PanelContainer


@export_multiline var content = 'Card Content.':
	set = _set_content

@export var pick_number = PickContainer.PICK_NUMBER.NONE:
	set = _set_pick_number


@onready var _content_lbl = $Container/Content
@onready var _pick_lbl: PickContainer = $Container/PickContainer


func _ready():
	_content_lbl.text = content
	_pick_lbl.pick_number = pick_number


func _set_content(value):
	content = value
	if _content_lbl:
		_content_lbl.text = content


func _set_pick_number(value: PickContainer.PICK_NUMBER):
	pick_number = value
	if _pick_lbl:
		_pick_lbl.pick_number = pick_number
