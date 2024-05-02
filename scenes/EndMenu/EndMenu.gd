extends Control

const GameOver_Text = "You lose..."
const Win_Text = "You won!"

const confirm_menu = "Go back to Main Menu ?"
const confirm_restart = "Restart the Game ?"
const confirm_quit = "Quit the Game ?"

@onready var end_message = %EndMessage
@onready var confirm_popup = %ConfirmationDialog

func _ready():
	if OS.has_feature("web"):
		%ExitButton.hide()
		
func set_win():
	end_message.text = Win_Text
	
func set_gameover():
	end_message.text = GameOver_Text

func show_confirm_popup(confirm_text:String, on_ok_pressed:Callable):
	confirm_popup.dialog_text = confirm_text
	
	var button_pressed_signal:Signal = confirm_popup.get_ok_button().pressed
	
	var button_pressed_signal_connections = button_pressed_signal.get_connections()
	
	match button_pressed_signal_connections.size():
		1:
			var button_pressed_signal_1_callable = button_pressed_signal_connections[0]["callable"]
	
			if button_pressed_signal_1_callable != on_ok_pressed:
				button_pressed_signal.disconnect(button_pressed_signal_1_callable)
				button_pressed_signal.connect(on_ok_pressed)
		0:
			pass
		_:
			push_error(name, "button_pressed_signal_connections size should be 0 or 1 !")
			return
			
	confirm_popup.popup()

func _on_restart_button_pressed():
	show_confirm_popup(confirm_restart, _on_confirm_restart_confirmed)

func _on_exit_button_pressed():
	show_confirm_popup(confirm_quit, _on_confirm_exit_confirmed)

func _on_main_menu_button_pressed():
	show_confirm_popup(confirm_menu, _on_confirm_main_menu_confirmed)

func _on_confirm_restart_confirmed():
	get_tree().paused = false
	SceneLoader.change_scene(get_tree().current_scene.scene_file_path)

func _on_confirm_main_menu_confirmed():
	get_tree().paused = false
	SceneLoader.change_scene(ProjectSettings.get_setting(RakugoGameTemplate.main_menu_setting_path))

func _on_confirm_exit_confirmed():
	get_tree().quit()
