extends ConfirmationDialog

var current_callable : Callable

func _ready():
	get_ok_button().pressed.connect(hide)

func popup_confirm(confirm_text:String, on_ok_pressed:Callable):
	dialog_text = confirm_text
	
	var button_pressed_signal:Signal = get_ok_button().pressed
	
	if current_callable.is_valid() and current_callable != on_ok_pressed:
		button_pressed_signal.disconnect(current_callable)
	
	button_pressed_signal.connect(on_ok_pressed)
	
	current_callable = on_ok_pressed
		
	popup_centered_clamped()
