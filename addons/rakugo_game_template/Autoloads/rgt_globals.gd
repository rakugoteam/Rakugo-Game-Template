@tool
extends Node
class_name RGT_Globals

const rakugo_game_template_setting_path = "application/addons/rakugo_game_template"
const loading_scene_setting_path = rakugo_game_template_setting_path + "/loading_scene_path"
const main_menu_setting_path = rakugo_game_template_setting_path + "/main_menu_path"
const first_game_scene_setting_path = rakugo_game_template_setting_path + "/first_game_scene_path"

static var rakugo_game_template_setting: String:
	set(value):
		ProjectSettings.set_setting(
			rakugo_game_template_setting_path, value
		)
	get: return ProjectSettings.get_setting(
		rakugo_game_template_setting_path
	)

static var loading_scene_setting:
	set(value):
		ProjectSettings.set_setting(
			loading_scene_setting_path, value
		)
	get: return ProjectSettings.get_setting(
		loading_scene_setting_path
	)

static var main_menu_setting:
	set(value):
		ProjectSettings.set_setting(
			main_menu_setting_path, value
		)
	get: return ProjectSettings.get_setting(
		main_menu_setting_path
	)

static var first_game_scene_setting:
	set(value):
		ProjectSettings.set_setting(
			first_game_scene_setting_path, value
		)
	get: return ProjectSettings.get_setting(
		first_game_scene_setting_path
	)
