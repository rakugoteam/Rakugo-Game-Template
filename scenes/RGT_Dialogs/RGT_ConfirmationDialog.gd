extends ConfirmationDialog
class_name RGT_ConfirmationDialog

func _init() -> void:
	var dialog_label : Label = get_label()
	dialog_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	dialog_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	unresizable = true

func force_ok_pressed_callable(ok_pressed_callable:Callable):
	var ok_pressed_signal := get_ok_button().pressed
	
	SignalHelper.force_only_one_callable(ok_pressed_signal, ok_pressed_callable)

	if dialog_hide_on_ok:
		ok_pressed_signal.connect(hide)
