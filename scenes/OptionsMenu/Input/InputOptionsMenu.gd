extends Control

@export var input_actions : Dictionary = {
	"move_up" : "Up",
	"move_down" : "Down",
	"move_left" : "Left",
	"move_right" : "Right",
	"interact" : "Interact",
	"mouse_left" : "Shoot"
}

@onready var inputs_container = %InputsContainer
@onready var key_assignment_dialog = %KeyAssignmentDialog

var input_item_scene = preload("res://scenes/OptionsMenu/Input/InputItem.tscn")

var current_edit_input_item:Control

func _popup_set_event(input_item:Control) -> void:
	current_edit_input_item = input_item
	key_assignment_dialog.popup_centered_clamped()

func _ready():
	for input in input_actions:
		if InputMap.has_action(input):
			var input_item = input_item_scene.instantiate()
			input_item.name = input
			inputs_container.add_child(input_item)
			
			var input_events = InputMap.action_get_events(input)
			
			input_item.init(input_actions[input], input_events[0], _popup_set_event.bind(input_item))
		else:
			push_error("Action: " + input + ", is not defined in the Input Map !")

func _on_reset_button_pressed():
	# TODO
	pass

func _on_key_assignment_dialog_event_choosed(event):
	var input_name = current_edit_input_item.name
	
	InputMap.action_erase_event(input_name, current_edit_input_item._input_event)
	
	InputMap.action_add_event(input_name, event)
	
	AppSettings.set_input_action(input_name, event)
	
	current_edit_input_item._input_event = event

func _on_hidden():
	AppSettings.save_config_file()

func _on_tree_exiting():
	AppSettings.save_config_file()
