extends Node
## Managing all UI sounds in a scene from one place.

@export var audio_bus : StringName = &"SFX"

@export var audio_streams_pressed : Array[AudioStream]
@export var audio_streams_hovered : Array[AudioStream]

@onready var audio_stream_player = $AudioStreamPlayer

func get_one_audio_stream(array:Array):
	if array.is_empty():
		return null
	
	if array.size() == 1:
		return array[0]
		
	return array.pick_random()

func _on_event(audio_array:Array):
	audio_stream_player.stream = get_one_audio_stream(audio_array)
	audio_stream_player.play()
	
func _on_event_pressed():
	_on_event(audio_streams_pressed)
	
func _on_event_hovered():
	_on_event(audio_streams_hovered)

func _connect_stream_player(node : Node, signal_name : StringName, callable:Callable, unbind_count:int = 0) -> void:
	if unbind_count > 0:
		callable = callable.unbind(unbind_count)
	
	if not node.is_connected(signal_name, callable):
		node.connect(signal_name, callable)

func connect_ui_sounds(node: Node) -> void:
	if node is Button:
		_connect_stream_player(node, &"mouse_entered", _on_event_hovered)
		_connect_stream_player(node, &"pressed", _on_event_pressed)
		
		if node is OptionButton:
			_connect_stream_player(node, &"item_selected", _on_event_pressed, 1)
	elif node is TabBar:
		_connect_stream_player(node, &"tab_hovered", _on_event_hovered, 1)
		_connect_stream_player(node, &"tab_selected", _on_event_pressed, 1)
	elif node is Slider:
		_connect_stream_player(node, &"mouse_entered", _on_event_hovered)
		_connect_stream_player(node, &"value_changed", _on_event_hovered, 1)
	elif node is LineEdit:
		_connect_stream_player(node, &"mouse_entered", _on_event_hovered)
		_connect_stream_player(node, &"text_submitted", _on_event_pressed)
		
func _on_node_added(node:Node):
	if not node is Control:
		return
		
	connect_ui_sounds(node)

func _ready():
	if audio_streams_pressed.is_empty() and audio_streams_hovered.is_empty():
		return
	
	audio_stream_player.bus = audio_bus
	
	get_tree().node_added.connect(_on_node_added)
