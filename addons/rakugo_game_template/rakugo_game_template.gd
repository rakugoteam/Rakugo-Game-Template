@tool
extends EditorPlugin


func _enter_tree():
	add_autoload_singleton("AppConfig", "res://addons/rakugo_game_template/base/scenes/Autoloads/AppConfig.tscn")
	add_autoload_singleton("SceneLoader", "res://addons/rakugo_game_template/base/scenes/Autoloads/SceneLoader.tscn")
	add_autoload_singleton("ProjectMusicController", "res://addons/rakugo_game_template/base/scenes/Autoloads/ProjectMusicController.tscn")
	add_autoload_singleton("ProjectUISoundController", "res://addons/rakugo_game_template/base/scenes/Autoloads/ProjectUISoundController.tscn")

	ProjectSettings.set_setting("addons/rakugo_game_template/loading_scene_path", "res://scenes/LoadingScreen/LoadingScreen.tscn")
	ProjectSettings.set_setting("addons/rakugo_game_template/first_scene_to_load_path", "res://scenes/MainMenu/MainMenu.tscn")

func _exit_tree():
	remove_autoload_singleton("AppConfig")
	remove_autoload_singleton("SceneLoader")
	remove_autoload_singleton("ProjectMusicController")
	remove_autoload_singleton("ProjectUISoundController")
	
	ProjectSettings.set_setting("addons/rakugo_game_template/loading_scene_path", null)
	ProjectSettings.set_setting("addons/rakugo_game_template/first_scene_to_load_path", null)
