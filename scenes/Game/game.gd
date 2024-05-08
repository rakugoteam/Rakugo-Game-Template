extends Node
class_name Game

@onready var pause_menu = %PauseMenu
@onready var end_menu = %EndMenu

func _process(_delta):
	if pause_menu.visible == false and Input.is_action_just_pressed("ui_cancel"):
		pause_menu.show()
		pause_menu.set_process(true)
		get_tree().paused = true

func _on_win():
	end_menu.set_win()
	end_menu.show()
	get_tree().paused = true
	
func _on_gameover():
	end_menu.set_gameover()
	end_menu.show()
	get_tree().paused = true
