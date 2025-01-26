extends RGT_ConfirmationDialog
class_name RGT_YesNoDialog

## Emit when the dialog is rejected, i.e when the No button is pressed.
signal rejected

var no_button:Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ok_button_text = "Yes"
	
	no_button = add_button("No", true, "No")

	custom_action.connect(_on_custom_action)
	
func _on_custom_action(action:StringName):
	if action == "No":
		rejected.emit()
		
func force_no_pressed_callable(no_pressed_callable):
	var no_pressed_signal := no_button.pressed
	
	SignalHelper.force_only_one_callable(no_pressed_signal, no_pressed_callable)
	
	no_pressed_signal.connect(hide)
