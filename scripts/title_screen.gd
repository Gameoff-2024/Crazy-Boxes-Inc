extends Control

const PLAY := 0
const EXIT := 1

const MAIN = preload("res://scenes/main.tscn")

@onready var menu_container: VBoxContainer = $MenuContainer
@onready var selector_coldown: Timer = $SelectorColdown

var selected_menu_item = 0
var menu_items : Array[Node]
var selectors : Array

var play_hovered = false
var exit_hovered = false

func _ready() -> void:
	selectors = get_tree().get_nodes_in_group("selector")
	
	menu_items = menu_container.get_children()
	
	if menu_items.size() > 0:
		set_selected_item(0)
		selectors[0].show()
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if play_hovered:
			play()
		elif exit_hovered:
			exit()
			
	if event is InputEventMouseMotion:
		if play_hovered:
			set_selected_item(0)
		elif exit_hovered:
			set_selected_item(1)
		
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
				print(menu_items[selected_menu_item])
				if action == PLAY:
					play()
				if action == EXIT:
					exit()


func set_selected_item(item_index: int) -> void:
	selector_coldown.start()
	selected_menu_item = item_index
	var label = menu_items[item_index] as Label
	get_tree().call_group("selector", "inactive")
	selectors[item_index].active()


func play():
	get_tree().change_scene_to_packed(MAIN)
	
	
func exit():
	get_tree().quit()


func _on_play_label_mouse_entered() -> void:
	play_hovered = true


func _on_play_label_mouse_exited() -> void:
	play_hovered = false


func _on_exit_label_mouse_entered() -> void:
	exit_hovered = true


func _on_exit_label_mouse_exited() -> void:
	exit_hovered = false
