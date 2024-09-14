@tool
extends EditorPlugin


func _enter_tree():
	add_autoload_singleton("AppSettings", "res://addons/rakugo_game_template/Autoloads/AppSettings.gd")
	add_autoload_singleton("SceneLoader", "res://addons/rakugo_game_template/Autoloads/SceneLoader.gd")
	add_autoload_singleton("ProjectMusicController", "res://addons/rakugo_game_template/Autoloads/ProjectMusicController.tscn")
	add_autoload_singleton("UISoundManager", "res://addons/rakugo_game_template/Autoloads/UISoundManager/UISoundManager.tscn")
	add_autoload_singleton("Transitions", "res://addons/rakugo_game_template/Autoloads/Transitions/transitions.tscn")

	PluginHelper.create_or_init_settings_if_empty(
		RGT_Globals.loading_scene_setting_path,
		"res://scenes/LoadingScreen/LoadingScreen.tscn"
	)
	
	ProjectSettings.add_property_info({
		"name":RGT_Globals.loading_scene_setting_path,
		"type":TYPE_STRING,
		"hint":PROPERTY_HINT_FILE,
		"hint_string":"*.tscn"})
		
	PluginHelper.create_or_init_settings_if_empty(
		RGT_Globals.main_menu_setting_path, "res://scenes/MainMenu/MainMenu.tscn"
	)
	
	ProjectSettings.add_property_info({
		"name":RGT_Globals.main_menu_setting_path,
		"type":TYPE_STRING,
		"hint":PROPERTY_HINT_FILE,
		"hint_string":"*.tscn"})

	PluginHelper.create_or_init_settings_if_empty(
		RGT_Globals.first_game_scene_setting_path, "res://scenes/Game/game.tscn"
	)
	
	ProjectSettings.add_property_info({
		"name":RGT_Globals.first_game_scene_setting_path,
		"type":TYPE_STRING,
		"hint":PROPERTY_HINT_FILE,
		"hint_string":"*.tscn"})

func _exit_tree():
	remove_autoload_singleton("AppSettings")
	remove_autoload_singleton("SceneLoader")
	remove_autoload_singleton("ProjectMusicController")
	remove_autoload_singleton("UISoundManager")
	remove_autoload_singleton("Transitions")
	
	RGT_Globals.loading_scene_setting = null
	RGT_Globals.main_menu_setting = null
	RGT_Globals.first_game_scene_setting = null
