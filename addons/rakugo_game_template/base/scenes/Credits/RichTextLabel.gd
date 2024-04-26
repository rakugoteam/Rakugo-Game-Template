extends RichTextLabel

func _on_RichTextLabel_meta_clicked(meta:String):
	if meta.begins_with("https://"):
		var _err = OS.shell_open(meta)
