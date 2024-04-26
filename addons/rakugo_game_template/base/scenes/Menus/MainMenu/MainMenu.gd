class_name MainMenu
extends Control


@export_file("*.tscn") var game_scene_path : String
@export var options_packed_scene : PackedScene
@export var credits_packed_scene : PackedScene
@export var version_number : String = '0.0.0'

var options_scene
var credits_scene
var sub_menu

# Position : margin
@export_enum("Left","Right") var Template_position:String="Left"

@onready var header_margin = $VBoxContainer/HeaderMargin
@onready var menu_margin = $VBoxContainer/HBoxContainer/MenuMargin

@onready var play_button = %PlayButton
@onready var option_button = %OptionsButton
@onready var credit_button = %CreditsButton
@onready var exit_button = %ExitButton

@onready var menu_button_list = [play_button,option_button,credit_button,exit_button]

func load_scene(scene_path : String):
	SceneLoader.load_scene(scene_path)

func play_game():
	SceneLoader.load_scene(game_scene_path)

func _open_sub_menu(menu : Control):
	sub_menu = menu
	sub_menu.show()
	%BackButton.show()
	%MenuContainer.hide()

func _close_sub_menu():
	if sub_menu == null:
		return
	sub_menu.hide()
	sub_menu = null
	%BackButton.hide()
	%MenuContainer.show()

func _event_is_mouse_button_released(event : InputEvent):
	return event is InputEventMouseButton and not event.is_pressed()

func _event_skips_intro(event : InputEvent):
	return event.is_action_released("ui_accept") or \
		event.is_action_released("ui_select") or \
		event.is_action_released("ui_cancel") or \
		_event_is_mouse_button_released(event)

func _input(event):
	if event.is_action_released("ui_accept") and get_viewport().gui_get_focus_owner() == null:
		%MenuButtons.focus_first()

func _setup_for_web():
	if OS.has_feature("web"):
		%ExitButton.hide()

func _setup_version_name():
	AppLog.version_opened(version_number)
	$"%VersionNumber".text = "version : %s" % version_number

func _setup_play():
	if game_scene_path.is_empty():
		%PlayButton.hide()

func _setup_options():
	
	
	if Template_position=="Right" :
		header_margin.size_flags_horizontal  = SIZE_SHRINK_END
		#menu_margin.size_flags_horizontal = SIZE_SHRINK_END
		var hbox = $VBoxContainer/MarginContainer/HBoxContainer
		hbox.move_child(hbox.get_child(1),0)
		#hbox.layout_direction=LAYOUT_DIRECTION_RTL
		for button in menu_button_list:
			button.alignment = HORIZONTAL_ALIGNMENT_RIGHT

	if options_packed_scene == null:
		%OptionsButton.hide()
	else:
		options_scene = options_packed_scene.instantiate()
		options_scene.hide()
		%OptionsContainer.call_deferred("add_child", options_scene)

func _setup_credits():
	if credits_packed_scene == null:
		%CreditsButton.hide()
	else:
		credits_scene = credits_packed_scene.instantiate()
		credits_scene.hide()
		if credits_scene.has_signal("end_reached"):
			credits_scene.connect("end_reached", _on_credits_end_reached)
		%CreditsContainer.call_deferred("add_child", credits_scene)

func _ready():
	_setup_for_web()
	_setup_version_name()
	_setup_options()
	_setup_credits()
	_setup_play()

func _on_play_button_pressed():
	play_game()

func _on_options_button_pressed():
	_open_sub_menu(options_scene)

func _on_credits_button_pressed():
	_open_sub_menu(credits_scene)
	credits_scene.reset()

func _on_exit_button_pressed():
	get_tree().quit()

func _on_credits_end_reached():
	if sub_menu == credits_scene:
		_close_sub_menu()

func _on_back_button_pressed():
	_close_sub_menu()
