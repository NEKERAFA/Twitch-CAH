class_name PickContainer
extends HBoxContainer


enum PICK_NUMBER { NONE = 0, TWO = 2, THREE = 3 }

const PICK_TEXTURES = [ 
	preload('res://assets/textures/pick-2.png'), 
	preload('res://assets/textures/pick-3.png')
]


@export var pick_number = PICK_NUMBER.NONE:
	set = _set_pick_number


@onready var _number_tex = $Number


func _ready():
	_update_number_texture()


func _update_number_texture():
	var texture = PICK_TEXTURES[pick_number - 2]
	if texture != null:
		_number_tex.texture = texture


func _set_pick_number(value):
	pick_number = value

	if pick_number == PICK_NUMBER.NONE:
		visible = false
	elif _number_tex:
		visible = true
		_update_number_texture()
