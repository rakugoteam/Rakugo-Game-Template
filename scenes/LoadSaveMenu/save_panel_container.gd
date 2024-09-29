extends PanelContainer

@onready var name_label = %NameLabel
@onready var save_texture = %SaveTextureRect
@onready var load_button = %LoadButton
@onready var delete_button = %DeleteButton

func init(save_name:String):
	name_label.text = save_name
	
	var image_path := SaveHelper.save_dir_path + "/" + save_name + ".png"
	
	if not FileAccess.file_exists(image_path):
		return
	
	var image := Image.load_from_file(image_path)
	
	if image == null:
		return
		
	save_texture.texture = ImageTexture.create_from_image(image)
	
