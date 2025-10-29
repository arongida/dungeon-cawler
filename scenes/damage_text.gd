class_name DamageText
extends Label


func _ready():
	position.y -= 60
	scale *= 1.5

func start_animation():
	var alpha_tween = get_tree().create_tween()
	alpha_tween.tween_method(_set_alpha, 1.0, 0.0, 2)
	alpha_tween.tween_callback(queue_free)
	
	var transform_tween = get_tree().create_tween()
	transform_tween.tween_method(_set_y_pos, -60, -100, 1.5)
	

func _set_alpha(to_value):
	modulate.a = to_value

func _set_y_pos(to_y_pos):
	position.y = to_y_pos
