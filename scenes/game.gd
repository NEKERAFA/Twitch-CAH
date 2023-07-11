extends Control


var _random = RandomNumberGenerator.new()
var _current_card = 0
var _selectable_cards = []


func _ready():
	_random.randomize()
	show_master_card()


func initialize_master_card(card_info):
	$MasterCard.content = card_info["text"]
	$MasterCard.pick_number = PickContainer.PICK_NUMBER.NONE if card_info["pick"] < 2 else card_info["pick"]
	$MasterCard.position.y = - (20 + $MasterCard.size.y)
	$MasterCard.rotation_degrees = _random.randf_range(-45.0, 45.0)


func show_master_card():
	var window_dimensions = DisplayServer.window_get_size()

	var master_card = $DeckManager.pick_master_card()
	initialize_master_card(master_card)
	
	var animate_position = create_tween()
	animate_position.tween_property($MasterCard, "position:y", 45, 0.5).set_trans(Tween.TRANS_QUAD)
	animate_position.tween_callback(show_card)

	var animate_rotation = create_tween()
	animate_rotation.tween_property($MasterCard, "rotation_degrees", _random.randf_range(-5.0, 5.0), 0.5).set_trans(Tween.TRANS_QUAD)


func initialize_card(card_node, card_info):
	var window_dimensions = DisplayServer.window_get_size()

	card_node.content = card_info['content']
	card_node.position.y = 620
	card_node.position.x = window_dimensions.x / 2 - card_node.size.x / 2
	card_node.rotation_degrees = randf_range(-45.0, 45.0)


func show_card():
	_current_card = _current_card + 1

	if _current_card <= 4:
		if _selectable_cards.is_empty():
			_selectable_cards.append_array($DeckManager.get_selectable_cards())

		var window_dimensions = DisplayServer.window_get_size()

		var card_node = get_node("Card{0}".format([_current_card]))
		var card_info = _selectable_cards[_current_card - 1]
		initialize_card(card_node, card_info)

		var animate_position = create_tween()
		var last_pos = Vector2(
			window_dimensions.x * _current_card * 2 / 10 - card_node.size.x / 2,
			window_dimensions.y - card_node.size.y - 45
		)
		animate_position.tween_property(card_node, "position", last_pos, 0.5).set_trans(Tween.TRANS_QUAD)
		animate_position.tween_callback(show_card)
		
		var animate_rotation = create_tween()
		animate_rotation.tween_property(card_node, "rotation_degrees", randf_range(-5.0, 5.0), 0.5).set_trans(Tween.TRANS_QUAD)
