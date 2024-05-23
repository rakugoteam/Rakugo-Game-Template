@tool
extends Node

const rakugo_game_template_setting_path = "application/addons/rakugo_game_template"
const loading_scene_setting_path = rakugo_game_template_setting_path + "/loading_scene_path"
const main_menu_setting_path = rakugo_game_template_setting_path + "/main_menu_path"
const first_game_scene_setting_path = rakugo_game_template_setting_path + "/first_game_scene_path"

var rakugo_game_template_setting: String:
	set(value):
		ProjectSettings.set_setting(
			rakugo_game_template_setting_path, value
		)
	get: return ProjectSettings.get_setting(
		rakugo_game_template_setting_path
	)

var loading_scene_setting:
	set(value):
		ProjectSettings.set_setting(
			loading_scene_setting_path, value
		)
	get: return ProjectSettings.get_setting(
		loading_scene_setting_path
	)

var main_menu_setting:
	set(value):
		ProjectSettings.set_setting(
			main_menu_setting_path, value
		)
	get: return ProjectSettings.get_setting(
		main_menu_setting_path
	)

var first_game_scene_setting:
	set(value):
		ProjectSettings.set_setting(
			first_game_scene_setting_path, value
		)
	get: return ProjectSettings.get_setting(
		first_game_scene_setting_path
	)

func _tree_enter():
	loading_scene_setting = "res://scenes/LoadingScreen/LoadingScreen.tscn"
	main_menu_setting = "res://scenes/MainMenu/MainMenu.tscn"
	first_game_scene_setting = "res://scenes/Game/game.tscn"

func _exit_tree():
	loading_scene_setting = null
	main_menu_setting = null
	first_game_scene_setting = null
