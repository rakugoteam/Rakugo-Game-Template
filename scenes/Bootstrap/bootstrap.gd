extends Node

#only here to load the first scene
#you can use this scene to show your splashscreen

func _ready():
	SceneLoader.change_scene(RGT_Globals.main_menu_setting, true, false)
