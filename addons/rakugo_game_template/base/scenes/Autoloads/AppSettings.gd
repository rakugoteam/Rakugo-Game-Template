extends Node
## Interface to read/write general application settings through [Config].

const CONFIG_FILE_LOCATION := "user://config.cfg"

const INPUT_SECTION = 'InputSettings'
const AUDIO_SECTION = 'AudioSettings'
const VIDEO_SECTION = 'VideoSettings'

const FULLSCREEN_ENABLED = 'FullscreenEnabled'
const SCREEN_RESOLUTION = 'ScreenResolution'
const MUTE_SETTING = 'Mute'
const MASTER_BUS_INDEX = 0

var config_file := ConfigFile.new()

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

func save_config_file():
	config_file.save(CONFIG_FILE_LOCATION)

# Input
func set_input_action(action_name:String, input_event:InputEvent):
	config_file.set_value(INPUT_SECTION, action_name, input_event)

func reset_to_default_inputs() -> void:
	# TODO
	pass

# Audio
static func get_bus_volume(bus_name : String) -> float:
	var bus_index : int = AudioServer.get_bus_index(bus_name)
	if bus_index < 0:
		return 0.0
	return AudioServer.get_bus_volume_db(bus_index)

static func get_bus_volume_to_linear(bus_name : String) -> float:
	return db_to_linear(get_bus_volume(bus_name))

static func set_bus_volume(bus_name : String, volume_db : float) -> void:
	var bus_index : int = AudioServer.get_bus_index(bus_name)
	if bus_index < 0:
		return
	AudioServer.set_bus_volume_db(bus_index, volume_db)
	Config.set_config(AUDIO_SECTION, bus_name, volume_db)

static func set_bus_volume_from_linear(bus_name : String, linear : float) -> void:
	set_bus_volume(bus_name, linear_to_db(linear))

static func is_muted() -> bool:
	return AudioServer.is_bus_mute(MASTER_BUS_INDEX)

static func set_mute(mute_flag : bool) -> void:
	AudioServer.set_bus_mute(MASTER_BUS_INDEX, mute_flag)
	Config.set_config(AUDIO_SECTION, MUTE_SETTING, mute_flag)

static func set_audio_from_config():
	for bus_iter in AudioServer.bus_count:
		var bus_name : String = AudioServer.get_bus_name(bus_iter)
		var bus_volume_db : float = AudioServer.get_bus_volume_db(bus_iter)
		bus_volume_db = Config.get_config(AUDIO_SECTION, bus_name, bus_volume_db)
		if is_nan(bus_volume_db):
			bus_volume_db = 1.0
			Config.set_config(AUDIO_SECTION, bus_name, bus_volume_db)
		AudioServer.set_bus_volume_db(bus_iter, bus_volume_db)
	var mute_audio_flag : bool = is_muted()
	mute_audio_flag = Config.get_config(AUDIO_SECTION, MUTE_SETTING, mute_audio_flag)
	set_mute(mute_audio_flag)

# Video

static func set_fullscreen_enabled(value : bool, window : Window) -> void:
	window.mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (value) else Window.MODE_WINDOWED
	Config.set_config(VIDEO_SECTION, FULLSCREEN_ENABLED, value)

static func set_resolution(value : Vector2i, window : Window) -> void:
	if value.x == 0 or value.y == 0:
		return
	window.size = value
	Config.set_config(VIDEO_SECTION, SCREEN_RESOLUTION, value)

static func reset_video_config(window : Window) -> void:
	Config.set_config(VIDEO_SECTION, FULLSCREEN_ENABLED, ((window.mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (window.mode == Window.MODE_FULLSCREEN)))

static func is_fullscreen(window : Window) -> bool:
	return (window.mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (window.mode == Window.MODE_FULLSCREEN)

static func get_resolution(window : Window) -> Vector2i:
	var current_resolution : Vector2i = window.size
	current_resolution = Config.get_config(VIDEO_SECTION, SCREEN_RESOLUTION, current_resolution)
	return current_resolution

static func set_video_from_config(window : Window) -> void:
	var fullscreen_enabled : bool = is_fullscreen(window)
	fullscreen_enabled = Config.get_config(VIDEO_SECTION, FULLSCREEN_ENABLED, fullscreen_enabled)
	set_fullscreen_enabled(fullscreen_enabled, window)
	if not (fullscreen_enabled or OS.has_feature("web")):
		var current_resolution : Vector2i = get_resolution(window)
		set_resolution(current_resolution, window)
