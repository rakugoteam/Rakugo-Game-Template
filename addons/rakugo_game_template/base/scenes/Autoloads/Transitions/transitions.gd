extends CanvasLayer

@onready var texture = $TextureRect
@onready var transition_animate = $AnimationPlayer

const CIRCLE_MASK = preload("res://addons/rakugo_game_template/base/scenes/Autoloads/Transitions/Shaders/Circle_mask.gdshader")
const DIAMOND = preload("res://addons/rakugo_game_template/base/scenes/Autoloads/Transitions/Shaders/Diamond.gdshader")
const LINE = preload("res://addons/rakugo_game_template/base/scenes/Autoloads/Transitions/Shaders/Line.gdshader")
const SQUARE_MASK = preload("res://addons/rakugo_game_template/base/scenes/Autoloads/Transitions/Shaders/Square_mask.gdshader")
const SWIPE_MASK = preload("res://addons/rakugo_game_template/base/scenes/Autoloads/Transitions/Shaders/Swipe_Mask.gdshader")

enum transition_type {Swipe,Square,Circle,Diamond,Line}

func screen_ratio ():
	var x = texture.get_size() 
	return x[1]/x[0]

func transition (transition_name:transition_type, reverse :bool = false) :
	var transition_name_str :String
	match transition_name:

		transition_type.Swipe:
			transition_name_str = "Swipe"
			texture.material.shader = SWIPE_MASK
		transition_type.Square:
			transition_name_str = "Square"
			texture.material.shader = SQUARE_MASK
		transition_type.Circle:
			transition_name_str = "Circle"
			texture.material.shader = CIRCLE_MASK
			texture.material.set("shader_parameter/size_ratio", screen_ratio())
		transition_type.Diamond:
			transition_name_str = "Diamond"
			texture.material.shader = DIAMOND
		transition_type.Line:
			transition_name_str = "Line"
			texture.material.shader = LINE

	if !reverse : 
		transition_animate.play(transition_name_str)
	else :
		transition_animate.play_backwards(transition_name_str)


