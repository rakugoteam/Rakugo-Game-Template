extends Node
class_name Game

@onready var pause_menu = %PauseMenu
@onready var end_menu = %EndMenu

@onready var pause_checker_sprite = $PauseChecker

func _ready() -> void:
	if SaveHelper.save_file_name_to_load.is_empty():
		return
	
	if not SaveHelper.load_saved_file_name() == OK:
		return
	
	pause_checker_sprite.rotation = \
		SaveHelper.last_loaded_data.get("pause_checker_sprite_rot", 0)

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

func _on_pause_menu_ask_to_save() -> void:
	pause_menu.save_this_please({
		"pause_checker_sprite_rot":pause_checker_sprite.rotation
	})
