class_name DeckManager
extends Node


@export var deck_name = "default"


var _random = RandomNumberGenerator.new()

var _master_deck = []
var _discarted_master_deck = []
var _selectable_deck = []
var _discarted_selectable_deck = []


func _ready():
	_random.randomize()
	load_deck()


func load_deck():
	var deck = $"/root/DecksManager".get_deck(deck_name)
	_master_deck = Array(deck["masters"])
	_master_deck.shuffle()
	_selectable_deck = Array(deck["selectables"])
	_selectable_deck.shuffle()


func pick_master_card():
	var card_pos = _random.randi() % _master_deck.size()
	var master_card = _master_deck.pop_at(card_pos)
	_discarted_master_deck.push_back(master_card)
	return master_card


func get_selectable_cards():
	var selectable_cards = []
	
	while selectable_cards.size() < 4:
		var card_pos = _random.randi() % _selectable_deck.size()
		var card = _selectable_deck.pop_at(card_pos)
		var card_info = { 'position': card_pos, 'content': card }
		_discarted_selectable_deck.push_back(card_info)
		selectable_cards.push_back(card_info)

	return selectable_cards
