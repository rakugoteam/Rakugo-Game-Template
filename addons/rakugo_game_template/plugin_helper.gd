extends Object
class_name PluginHelper

static func create_or_init_settings_if_empty(setting_path:String, setting_value:Variant):
	if ProjectSettings.get_setting(setting_path, "").is_empty():
		ProjectSettings.set_setting(setting_path, setting_value)
