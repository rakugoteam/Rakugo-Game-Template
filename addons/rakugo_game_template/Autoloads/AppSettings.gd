extends Node
## Interface to read/write general application settings

const CONFIG_FILE_LOCATION := "user://config.cfg"

const INPUT_SECTION = 'InputSettings'
const AUDIO_SECTION = 'AudioSettings'
const VIDEO_SECTION = 'VideoSettings'

const FULLSCREEN_ENABLED = 'FullscreenEnabled'
const SCREEN_RESOLUTION = 'ScreenResolution'
const GUI_SCALE = 'GuiScale'
const MUTE_SETTING = 'Mute'
const BUSSES_VOLUME = 'BussesVolume'
const MASTER_BUS_INDEX = 0

var config_file := ConfigFile.new()

var busses_volume := {}

func _ready():
	var err = config_file.load(CONFIG_FILE_LOCATION)
	
	if err != OK:
		return
	
	#load input_events
	if config_file.has_section(INPUT_SECTION):
		var action_names = config_file.get_section_keys(INPUT_SECTION)
		
		for action_name in action_names:
			if not InputMap.has_action(action_name):
				push_error("Action: " + action_name + ", does not exist in the InputMap !")
				continue
				
			InputMap.action_erase_events(action_name)
			InputMap.action_add_event(
				action_name,
				config_file.get_value(INPUT_SECTION, action_name))
	
	#audio
	if config_file.has_section(AUDIO_SECTION):
		if config_file.get_value(AUDIO_SECTION, MUTE_SETTING, false):
			AudioServer.set_bus_mute(MASTER_BUS_INDEX, true)
			
		var dictio = config_file.get_value(AUDIO_SECTION, BUSSES_VOLUME, {})
		
		for bus_index in dictio:
			AudioServer.set_bus_volume_db(bus_index, linear_to_db(dictio[bus_index]))
	
	#video
	if config_file.has_section(VIDEO_SECTION):
		var main_window = get_window()
		
		if config_file.get_value(VIDEO_SECTION, FULLSCREEN_ENABLED, is_master_muted()):
			main_window.mode = Window.MODE_EXCLUSIVE_FULLSCREEN
			
		if config_file.has_section_key(VIDEO_SECTION, SCREEN_RESOLUTION):
			var res_value = config_file.get_value(VIDEO_SECTION, SCREEN_RESOLUTION)
			
			main_window.content_scale_size = res_value
			
			if main_window.mode != Window.MODE_EXCLUSIVE_FULLSCREEN:
				main_window.size = res_value
				
		if config_file.has_section_key(VIDEO_SECTION, GUI_SCALE):
			main_window.content_scale_factor = config_file.get_value(VIDEO_SECTION, GUI_SCALE)

func save_config_file():
	config_file.save(CONFIG_FILE_LOCATION)

# Input
func set_input_action(action_name:String, input_event:InputEvent):
	config_file.set_value(INPUT_SECTION, action_name, input_event)

func reset_to_default_inputs() -> void:
	# TODO
	pass

# Audio
func set_bus_volume_from_linear(bus_index : int, linear : float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(linear))
	
	busses_volume[bus_index] = linear
	
	config_file.set_value(AUDIO_SECTION, BUSSES_VOLUME, busses_volume)

func is_master_muted() -> bool:
	return AudioServer.is_bus_mute(MASTER_BUS_INDEX)

func set_mute(mute_flag : bool) -> void:
	AudioServer.set_bus_mute(MASTER_BUS_INDEX, mute_flag)
	
	config_file.set_value(AUDIO_SECTION, MUTE_SETTING, mute_flag)

# Video
func set_fullscreen(value:bool):
	var main_window = get_window()
	
	main_window.mode = Window.MODE_EXCLUSIVE_FULLSCREEN if value else Window.MODE_WINDOWED
	
	if main_window.mode == Window.MODE_WINDOWED:
		main_window.size = config_file.get_value(VIDEO_SECTION, SCREEN_RESOLUTION,
			Vector2i(
				ProjectSettings.get_setting("display/window/size/viewport_width"),
				ProjectSettings.get_setting("display/window/size/viewport_height")))
	
	config_file.set_value(VIDEO_SECTION, FULLSCREEN_ENABLED, value)

func set_resolution(value : Vector2i) -> void:
	var main_window = get_window()
	
	main_window.content_scale_size = value
	
	if main_window.mode != Window.MODE_EXCLUSIVE_FULLSCREEN:
		main_window.size = value
		
	config_file.set_value(VIDEO_SECTION, SCREEN_RESOLUTION, value)

func set_gui_scale(value:float) -> void:
	var main_window = get_window()
	
	main_window.content_scale_factor = value

	config_file.set_value(VIDEO_SECTION, GUI_SCALE, value)
