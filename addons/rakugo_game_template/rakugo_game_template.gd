@tool
extends EditorPlugin
class_name  RakugoGameTemplate

const rakugo_game_template_setting_path = "application/addons/rakugo_game_template"
const loading_scene_setting_path = rakugo_game_template_setting_path + "/loading_scene_path"
const main_menu_setting_path = rakugo_game_template_setting_path + "/main_menu_path"
const first_game_scene_setting_path = rakugo_game_template_setting_path + "/first_game_scene_path"

func _enter_tree():
	add_autoload_singleton("AppSettings", "res://addons/rakugo_game_template/Autoloads/AppSettings.gd")
	add_autoload_singleton("SceneLoader", "res://addons/rakugo_game_template/Autoloads/SceneLoader.gd")
	add_autoload_singleton("ProjectMusicController", "res://addons/rakugo_game_template/Autoloads/ProjectMusicController.tscn")
	add_autoload_singleton("UISoundManager", "res://addons/rakugo_game_template/Autoloads/UISoundManager/UISoundManager.tscn")
	add_autoload_singleton("Transitions", "res://addons/rakugo_game_template/Autoloads/Transitions/transitions.tscn")
	
	ProjectSettings.set_setting(loading_scene_setting_path, "res://scenes/LoadingScreen/LoadingScreen.tscn")
	ProjectSettings.set_setting(main_menu_setting_path, "res://scenes/MainMenu/MainMenu.tscn")
	ProjectSettings.set_setting(first_game_scene_setting_path, "res://scenes/Game/game.tscn")

func _exit_tree():
	remove_autoload_singleton("AppSettings")
	remove_autoload_singleton("SceneLoader")
	remove_autoload_singleton("ProjectMusicController")
	remove_autoload_singleton("UISoundManager")
	remove_autoload_singleton("Transitions")
	
	ProjectSettings.set_setting(loading_scene_setting_path, null)
	ProjectSettings.set_setting(main_menu_setting_path, null)
	ProjectSettings.set_setting(first_game_scene_setting_path, null)
