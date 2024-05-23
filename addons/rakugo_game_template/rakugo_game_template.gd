@tool
extends EditorPlugin


func _enter_tree():
	add_autoload_singleton("RGT_Globals", "res://addons/rakugo_game_template/Autoloads/rgt_globals.gd")
	add_autoload_singleton("AppSettings", "res://addons/rakugo_game_template/Autoloads/AppSettings.gd")
	add_autoload_singleton("SceneLoader", "res://addons/rakugo_game_template/Autoloads/SceneLoader.gd")
	add_autoload_singleton("ProjectMusicController", "res://addons/rakugo_game_template/Autoloads/ProjectMusicController.tscn")
	add_autoload_singleton("UISoundManager", "res://addons/rakugo_game_template/Autoloads/UISoundManager/UISoundManager.tscn")
	add_autoload_singleton("Transitions", "res://addons/rakugo_game_template/Autoloads/Transitions/transitions.tscn")

func _exit_tree():
	remove_autoload_singleton("RGT_Globals")
	remove_autoload_singleton("AppSettings")
	remove_autoload_singleton("SceneLoader")
	remove_autoload_singleton("ProjectMusicController")
	remove_autoload_singleton("UISoundManager")
	remove_autoload_singleton("Transitions")
	

