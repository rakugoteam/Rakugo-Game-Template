extends HBoxContainer

@onready var input_name_label = $InputName
@onready var input_key_button = $InputKey

var _input_event:InputEvent:
	set(value):
		_input_event = value
		input_key_button.text = value.as_text()

func init(inputName:String, input_event:InputEvent, pressed:Callable):
	input_name_label.text = inputName
	_input_event = input_event
	input_key_button.pressed.connect(pressed)

func get_input_name():
	return input_name_label.text
