class_name MainMenu
extends Control

var sub_menu

@onready var continue_button = %ContinueButton
@onready var play_button = %PlayButton
@onready var load_button = %LoadButton

@onready var load_save_menu = %LoadSaveMenu
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

func _ready():
	if OS.has_feature("web"):
		%ExitButton.hide()
	else:
		confirm_popup.get_ok_button().pressed.connect(_on_exit_confirmed)
		
	%VersionNumber.text = "version : " + str(ProjectSettings.get_setting("application/config/version", ""))
	
	if RGT_Globals.loading_scene_setting.is_empty():
		play_button.hide()
	
	if SaveHelper.save_file_names.is_empty():
		continue_button.hide()
		load_button.hide()

func _on_continue_button_pressed() -> void:
	SaveHelper.update_with_last_saved_name()
	
	SceneLoader.change_scene(RGT_Globals.first_game_scene_setting)

func _on_play_button_pressed():
	SaveHelper.save_file_name_to_load = ""
	
	SceneLoader.change_scene(RGT_Globals.first_game_scene_setting)

func _on_load_button_pressed() -> void:
	_open_sub_menu(load_save_menu)

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

func _on_load_save_menu_no_save_to_load() -> void:
	continue_button.hide()
	load_button.hide()
	
	_close_sub_menu()
