extends AcceptDialog

signal event_choosed(event)

func _ready():
	get_label().horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	get_ok_button().hide()

func _record_input_event(event : InputEvent):
	event_choosed.emit(event)
	hide()

func _is_recordable_input(event : InputEvent):
	return event is InputEventKey or event is InputEventMouseButton or event is InputEventJoypadButton or (event is InputEventJoypadMotion and abs(event.axis_value) > 0.5)

func _input(event):
	if not visible:
		return
	if _is_recordable_input(event):
		_record_input_event(event)
