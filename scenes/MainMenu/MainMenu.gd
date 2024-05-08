class_name MainMenu
extends Control

@export var version_number : String = '0.0.0'

var sub_menu

# Position : margin
@export_enum("Left","Right") var Template_position:String="Left"

@onready var header_margin = $VBoxContainer/HeaderMargin

@onready var play_button = %PlayButton
@onready var option_button = %OptionsButton
@onready var credit_button = %CreditsButton
@onready var exit_button = %ExitButton
@onready var menu_button_list = [play_button,option_button,credit_button,exit_button]

@onready var option_menu = %OptionsMenu
@onready var credit_menu = %CreditsContainer

@onready var confirm_popup = %ConfirmationDialog

func _open_sub_menu(menu : Control):
	if sub_menu == menu:
		sub_menu.visible = !sub_menu.visible
		return
	if sub_menu != null:
		sub_menu.hide()
	sub_menu = menu
	sub_menu.show()


func _close_sub_menu():
	if sub_menu == null:
		return
	sub_menu.hide()
	sub_menu = null


func _event_is_mouse_button_released(event : InputEvent):
	return event is InputEventMouseButton and not event.is_pressed()

func _event_skips_intro(event : InputEvent):
	return event.is_action_released("ui_accept") or \
		event.is_action_released("ui_select") or \
		event.is_action_released("ui_cancel") or \
		_event_is_mouse_button_released(event)

func _ready():
	if OS.has_feature("web"):
		%ExitButton.hide()
	else:
		confirm_popup.get_ok_button().pressed.connect(_on_exit_confirmed)
		
	%VersionNumber.text = "version : %s" % version_number
	
	if Template_position=="Right" :
		header_margin.size_flags_horizontal  = SIZE_SHRINK_END
		#menu_margin.size_flags_horizontal = SIZE_SHRINK_END
		var hbox = $VBoxContainer/MarginContainer/HBoxContainer
		hbox.move_child(hbox.get_child(1),0)
		hbox.alignment = BoxContainer.ALIGNMENT_END
		for button in menu_button_list:
			button.alignment = HORIZONTAL_ALIGNMENT_RIGHT
	
	if ProjectSettings.get_setting(RakugoGameTemplate.loading_scene_setting_path).is_empty():
		play_button.hide()

func _on_play_button_pressed():
	SceneLoader.change_scene(ProjectSettings.get_setting(RakugoGameTemplate.first_game_scene_setting_path))

func _on_options_button_pressed():
	_open_sub_menu(option_menu)

func _on_credits_button_pressed():
	_open_sub_menu(credit_menu)

func _on_exit_button_pressed():
	confirm_popup.popup_centered_clamped()
	
func _on_exit_confirmed():
	get_tree().quit()

func _on_back_button_pressed():
	_close_sub_menu()
