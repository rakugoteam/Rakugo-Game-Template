extends Control

@export var hide_busses : Array[String]

const audio_control_scene = preload("res://scenes/OptionsMenu/Audio/AudioControl/AudioControl.tscn")

func _ready():
	%MuteButton.set_pressed_no_signal(AudioServer.is_bus_mute(0))
	
	for bus_index in AudioServer.bus_count:
		var audio_control = audio_control_scene.instantiate()
		audio_control.bus_index = bus_index
		audio_control.bus_value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
		
		%AudioControlContainer.add_child(audio_control)

func _on_mute_button_toggled(toggled_on):
	AppSettings.set_mute(toggled_on)
