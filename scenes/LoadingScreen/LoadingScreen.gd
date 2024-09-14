extends Control

const LOADING_COMPLETE_TEXT = "Loading Complete!"
const CONTINUE_LABEL_TEXT = "Press any key to continue..."

@onready var status_label = %StatusLabel
@onready var continue_label = %ContinueLabel
@onready var progress_bar = %ProgressBar
@onready var flash_label = %AnimationPlayer

func _show_scene_switching_error_message():
	if %ErrorMessage.visible:
		return
	%ErrorMessage.dialog_text = "Loading Error: Failed to switch scenes."
	%ErrorMessage.popup_centered()

func _ready():
	if SceneLoader._scene_loading_complete:
		progress_bar.value = progress_bar.max_value
		status_label.text = LOADING_COMPLETE_TEXT
		continue_label.text = CONTINUE_LABEL_TEXT
		_flash_continue_label()
		set_process(false)
		return

func _process(_delta):
	var status = SceneLoader.get_status()
	match(status):
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			var new_progress = SceneLoader.get_progress()
			if new_progress > progress_bar.value:
				progress_bar.value = new_progress
		ResourceLoader.THREAD_LOAD_LOADED:
			if SceneLoader._force_wait_after_load:
				progress_bar.value = progress_bar.max_value
				status_label.text = LOADING_COMPLETE_TEXT
				continue_label.text = CONTINUE_LABEL_TEXT
				_flash_continue_label()
			set_process(false)
		ResourceLoader.THREAD_LOAD_FAILED:
			%ErrorMessage.dialog_text = "Loading Error: %d" % status
			%ErrorMessage.popup_centered()
			set_process(false)
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			%ErrorMessage.hide()
			set_process(false)

func _flash_continue_label ():
	continue_label.show()
	flash_label.play("Flash")
