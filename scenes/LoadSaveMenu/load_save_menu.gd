extends ScrollContainer

signal no_save_to_load

const confirm_load = "Are you sure you want to load this save?\n"
const confirm_delete = "Are you sure you want to delete this save ?\n"

var SavePanel = preload("res://scenes/LoadSaveMenu/savePanelContainer.tscn")

@onready var vbox_container = $VBoxContainer

@onready var confirm_dialog = %ConfirmationDialog

enum Modes{
	Loading,
	Deleting
}

var popup_mode = Modes.Loading
var current_save_file_name:String = ""
var current_save_panel:Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if SaveHelper.save_file_names.is_empty():
		SaveHelper.update_save_file_names()
	
	if SaveHelper.save_file_names.is_empty():
		push_warning("No save to load")
		pass
		
	for save_file_name in SaveHelper.save_file_names:
		var save_panel = SavePanel.instantiate()
		
		vbox_container.add_child(save_panel)
		
		save_panel.init(save_file_name)
		
		save_panel.load_button.pressed.connect(_on_load_button_pressed.bind(save_file_name))
		save_panel.delete_button.pressed.connect(
			_on_delete_button_pressed.bind(save_panel, save_file_name))

func _on_load_button_pressed(save_file_name:String):
	popup_mode = Modes.Loading
	
	current_save_file_name = save_file_name
	
	confirm_dialog.dialog_text = confirm_load + save_file_name
	
	confirm_dialog.popup_centered()
	
func _on_delete_button_pressed(save_panel:Node, save_file_name:String):
	popup_mode = Modes.Deleting
	
	current_save_file_name = save_file_name
	
	current_save_panel = save_panel
	
	confirm_dialog.dialog_text = confirm_delete + save_file_name
	
	confirm_dialog.popup_centered()

func _on_confirmation_dialog_confirmed() -> void:
	match(popup_mode):
		Modes.Loading:
			SaveHelper.save_file_name_to_load = current_save_file_name
	
			SceneLoader.change_scene(RGT_Globals.first_game_scene_setting)
			
		Modes.Deleting:
			SaveHelper.delete(current_save_file_name)
			
			# move to trash the screenshot
			OS.move_to_trash(
				ProjectSettings.globalize_path(
					SaveHelper.get_save_file_path_without_extension(current_save_file_name) + ".png"
				))
				
			SaveHelper.update_save_file_names()
			
			if SaveHelper.save_file_names.is_empty():
				no_save_to_load.emit()
			
			current_save_panel.queue_free()
	
