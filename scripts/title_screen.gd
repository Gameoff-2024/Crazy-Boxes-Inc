extends Control

const PLAY := 0
const EXIT := 1

const MAIN = preload("res://scenes/main.tscn")

@onready var menu_container: VBoxContainer = $MenuContainer
@onready var selector: Label = $Selector
@onready var selector_coldown: Timer = $SelectorColdown

var selected_menu_item = 0
var menu_items : Array[Node]

func _ready() -> void:
	menu_items = menu_container.get_children()
	
	if menu_items.size() > 0:
		set_selected_item(0)
		selector.show()
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
		
	if selector_coldown.is_stopped():
		if event is InputEventKey:
			if event.keycode == KEY_DOWN:
				if selected_menu_item + 1 >= menu_items.size():
					set_selected_item(0)
				else:
					set_selected_item(selected_menu_item + 1)
			elif event.keycode == KEY_UP:
				if selected_menu_item - 1 < 0:
					set_selected_item(menu_items.size() - 1)
				else:
					set_selected_item(selected_menu_item - 1)
			elif event.keycode == KEY_ENTER:
				var action = menu_items[selected_menu_item].get_meta("action", -1)
				if action == PLAY:
					get_tree().change_scene_to_packed(MAIN)
				if action == EXIT:
					get_tree().quit()

func set_selected_item(item_index: int) -> void:
	selector_coldown.start()
	selected_menu_item = item_index
	selector.global_position = menu_items[item_index].global_position - Vector2(40, 0)
