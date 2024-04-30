@tool
extends EditorPlugin
class_name  RakugoGameTemplate

const rakugo_game_template_setting_path = "application/addons/rakugo_game_template"
const loading_scene_setting_path = rakugo_game_template_setting_path + "/loading_scene_path"
const first_scene_to_load_path = rakugo_game_template_setting_path + "/first_scene_to_load_path"
const first_game_scene_setting_path = rakugo_game_template_setting_path + "/first_game_scene_path"

func _enter_tree():
	add_autoload_singleton("AppConfig", "res://addons/rakugo_game_template/base/scenes/Autoloads/AppConfig.tscn")
	add_autoload_singleton("SceneLoader", "res://addons/rakugo_game_template/base/scenes/Autoloads/SceneLoader.tscn")
	add_autoload_singleton("ProjectMusicController", "res://addons/rakugo_game_template/base/scenes/Autoloads/ProjectMusicController.tscn")
	add_autoload_singleton("ProjectUISoundController", "res://addons/rakugo_game_template/base/scenes/Autoloads/ProjectUISoundController.tscn")

	ProjectSettings.set_setting(loading_scene_setting_path, "res://scenes/LoadingScreen/LoadingScreen.tscn")
	ProjectSettings.set_setting(first_scene_to_load_path, "res://scenes/MainMenu/MainMenu.tscn")
	ProjectSettings.set_setting(first_game_scene_setting_path, "res://scenes/Game/game.tscn")

func _exit_tree():
	remove_autoload_singleton("AppConfig")
	remove_autoload_singleton("SceneLoader")
	remove_autoload_singleton("ProjectMusicController")
	remove_autoload_singleton("ProjectUISoundController")
	
	ProjectSettings.set_setting(loading_scene_setting_path, null)
	ProjectSettings.set_setting(first_scene_to_load_path, null)
	ProjectSettings.set_setting(first_game_scene_setting_path, null)
