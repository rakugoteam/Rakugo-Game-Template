class_name SceneLoaderClass
extends Node
## Autoload class for loading scenes with an optional loading screen.

signal scene_loaded

var _loading_screen : PackedScene
var _scene_path : String
var _loaded_resource : Resource

var _scene_loading_complete : bool = false
var _background_loading : bool
var _force_wait_after_load : bool = true

func _check_scene_path() -> bool:
	if _scene_path == null or _scene_path == "":
		push_warning("scene path is empty")
		return false
	return true

func get_status() -> ResourceLoader.ThreadLoadStatus:
	if not _check_scene_path():
		return ResourceLoader.THREAD_LOAD_INVALID_RESOURCE
	return ResourceLoader.load_threaded_get_status(_scene_path)

func get_progress() -> float:
	if not _check_scene_path():
		return 0.0
	var progress_array : Array = []
	ResourceLoader.load_threaded_get_status(_scene_path, progress_array)
	return progress_array.pop_back()

func get_resource():
	if not _check_scene_path():
		return
	var current_loaded_resource = ResourceLoader.load_threaded_get(_scene_path)
	if current_loaded_resource != null:
		_loaded_resource = current_loaded_resource
	return _loaded_resource

func change_scene_to_resource(open_transition:bool = true) -> void:
	var current_tree = get_tree()
	current_tree.paused = true
	
	if open_transition:
		Transitions.transition(Transitions.transition_type.Diamond)
		await Transitions.animation_player.animation_finished
	
	var err = current_tree.change_scene_to_packed(get_resource())
	if err:
		push_error("failed to change scenes: %d" % err)
		current_tree.quit()
	
	Transitions.transition(Transitions.transition_type.Diamond, true)
	await Transitions.animation_player.animation_finished
	
	current_tree.paused = false

func change_scene_to_loading_screen(open_transition:bool = true) -> void:
	get_tree().paused = true
	
	if open_transition:
		Transitions.transition(Transitions.transition_type.Diamond)
		await Transitions.animation_player.animation_finished
	
	var err = get_tree().call_deferred("change_scene_to_packed", _loading_screen)
	if err:
		push_error("failed to change scenes to loading screen: %d" % err)
		get_tree().quit()
	get_tree().paused = false
	set_process(true)
	Transitions.transition(Transitions.transition_type.Diamond, true)
	await Transitions.animation_player.animation_finished

func set_loading_screen(value : String) -> void:
	if value == "":
		push_warning("loading screen path is empty")
		return
	_loading_screen = load(value)

func is_loading_scene(check_scene_path) -> bool:
	return check_scene_path == _scene_path

func has_loading_screen() -> bool:
	return _loading_screen != null

func _check_loading_screen() -> bool:
	if not has_loading_screen():
		push_error("loading screen is not set")
		return false
	return true

func reload_current_scene() -> void:
	get_tree().reload_current_scene()

func load_scene_in_background(scene_path : String):
	if scene_path == null or scene_path.is_empty():
		push_error("no path given to load")
		return
	_scene_path = scene_path
	_scene_loading_complete = false
	_background_loading = true
	if ResourceLoader.has_cached(scene_path):
		_scene_loading_complete = true
		call_deferred("emit_signal", "scene_loaded")
		return
	ResourceLoader.load_threaded_request(_scene_path)
	set_process(true)

func change_scene(scene_path : String, force_wait_after_load : bool = true, open_transition:bool = true) -> void:
	if scene_path == null or scene_path.is_empty():
		push_error("no path given to load")
		return
	_scene_path = scene_path
	_scene_loading_complete = false
	_force_wait_after_load = force_wait_after_load
	if ResourceLoader.has_cached(scene_path):
		_scene_loading_complete = true
		call_deferred("emit_signal", "scene_loaded")
		if _force_wait_after_load:
			change_scene_to_loading_screen(open_transition)
			return
		change_scene_to_resource(open_transition)
		return
	ResourceLoader.load_threaded_request(_scene_path)
	change_scene_to_loading_screen(open_transition)

func _ready():
	set_process(false)
	set_loading_screen(RGT_Globals.loading_scene_setting)

func _process(_delta):
	if not _scene_loading_complete:
		var status = get_status()
		match(status):
			ResourceLoader.THREAD_LOAD_INVALID_RESOURCE, ResourceLoader.THREAD_LOAD_FAILED:
				set_process(false)
			ResourceLoader.THREAD_LOAD_LOADED:
				_scene_loading_complete = true
				emit_signal("scene_loaded")
				if _background_loading:
					set_process(false)
					return
				elif not _force_wait_after_load:
					change_scene_to_resource()
					set_process(false)
					return
	elif _force_wait_after_load and Input.is_anything_pressed():
		change_scene_to_resource()
		set_process(false)
		return
