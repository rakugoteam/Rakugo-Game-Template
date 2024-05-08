extends Control

@export var resolutions_array : Array[Vector2i] = [
	Vector2i(960, 540),
	Vector2i(1024, 576),
	Vector2i(1280, 720),
	Vector2i(1600, 900),
	Vector2i(1920, 1080),
	Vector2i(2048, 1152),
	Vector2i(2560, 1440),
	Vector2i(3200, 1800),
	Vector2i(3840, 2160),
]

@onready var fullscreen_button = %FullscreenButton
@onready var resolution_options = %ResolutionOptions

func _ready():
	var main_window = get_window()
	
	fullscreen_button.set_pressed_no_signal(main_window.mode == Window.MODE_EXCLUSIVE_FULLSCREEN)

	if OS.has_feature("web"):
		resolution_options.disabled = true
		resolution_options.tooltip_text = "Disabled for web"
	else:
		for resolution in resolutions_array:
			resolution_options.add_item(str(resolution.x) + " x " + str(resolution.y))
			
		var index = resolutions_array.find(main_window.content_scale_size)
		
		if index != -1:
			resolution_options.select(index)

func _on_fullscreen_button_toggled(toggled_on):
	AppSettings.set_fullscreen(toggled_on)

func _on_resolution_options_item_selected(index):
	AppSettings.set_resolution(resolutions_array[index])
