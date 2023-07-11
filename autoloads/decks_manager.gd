extends Node


const SYSTEM_DECKS_PATH = "res://assets/decks"
const USER_DECKS = "user://decks"
const DECK_EXTENSION = "json"


class DeckInfo:
	var deck_path: String
	var deck_name: String
	var is_user_deck: bool
	var is_loaded: bool
	var deck = null:
		set = set_deck


	func _init(deck_path, deck_name, is_user_deck):
		self.deck_path = deck_path
		self.deck_name = deck_name
		self.is_user_deck = is_user_deck
		self.is_loaded = false
		self.deck = null


	func set_deck(value):
		deck = value
		is_loaded = value != null


var _decks: Array = []


func _ready():
	load_decks_info()


# Loads decks info
func load_decks_info():
	_decks.clear()
	for path in [SYSTEM_DECKS_PATH, USER_DECKS]:
		_load_deck_info(path, path == USER_DECKS)


# Loads deck info
func _load_deck_info(path: String, is_user: bool):
	var dir = DirAccess.open(path)
	if dir and dir.list_dir_begin() == OK:
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.get_extension() == DECK_EXTENSION:
				_decks.append(DeckInfo.new(path.path_join(file_name), file_name.get_basename(), is_user))
#				var file = FileAccess.open(path.path_join(file_name), FileAccess.READ)
#				if file:
#					var content = file.get_as_text()
#					var deck = JSON.parse_string(content)
#					if deck:
#						print("<{0}> {1} loaded.".format([ file_name.get_basename(), path.path_join(file_name) ]))
#						_decks.append({ "name": file_name.get_basename(), "deck": deck })
			file_name = dir.get_next()
		dir.list_dir_end()


func get_deck(deck_name):
	var deck_info = null
	
	for info in _decks:
		if info.deck_name == deck_name:
			deck_info = info
			break

	if deck_info != null:
		if deck_info.is_loaded:
			return deck_info.deck
		else:
			return _load_deck(deck_info)

	return null

# Loads a deck
func _load_deck(deck_info):
	var file = FileAccess.open(deck_info.deck_path, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		var deck = JSON.parse_string(content)
		if deck:
			print("<{0}> {1} loaded.".format([ deck_info.deck_name, deck_info.deck_path ]))
			deck_info.deck = deck
			return deck

	return null
