extends CanvasLayer

@onready var color_rect = $ColorRect
@onready var stop_mouse = $StopMouse
@onready var animation_player = $AnimationPlayer

enum transition_type {Swipe,Square,Circle,Diamond,Line}

func screen_ratio ():
	var x = color_rect.get_size() 
	return x[1]/x[0]

func transition (transition_name:transition_type, reverse :bool = false) :
	stop_mouse.mouse_filter = Control.MOUSE_FILTER_STOP
	color_rect.show()
	
	var transition_name_str :String
	
	match transition_name:
		transition_type.Swipe:
			transition_name_str = "Swipe"
		transition_type.Square:
			transition_name_str = "Square"
		transition_type.Circle:
			transition_name_str = "Circle"
			color_rect.material.set("shader_parameter/size_ratio", screen_ratio())
		transition_type.Diamond:
			transition_name_str = "Diamond"
		transition_type.Line:
			transition_name_str = "Line"

	if reverse :
		animation_player.play_backwards(transition_name_str)
		return
		
	animation_player.play(transition_name_str)

func _on_animation_finished(anim_name):
	stop_mouse.mouse_filter = Control.MOUSE_FILTER_IGNORE
	color_rect.hide()
