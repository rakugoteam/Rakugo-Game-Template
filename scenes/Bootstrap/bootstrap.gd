extends Node

#only here to load the first scene
#you can use this scene to show your splashscreen

func _ready():
	SceneLoader.change_scene(ProjectSettings.get_setting(RakugoGameTemplate.main_menu_setting_path))
