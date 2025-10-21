class_name ThemeMusicPlayer
extends AudioStreamPlayer


func _update_pitch_scale(toValue: float):
	pitch_scale = toValue

func fadeOut():
	var tween = get_tree().create_tween()
	tween.tween_method(_update_pitch_scale, 1.0, 0.6, 2)

func fadeIn():
	if pitch_scale < 1:
		var tween = get_tree().create_tween()
		tween.tween_method(_update_pitch_scale, 0.6, 1.0, 2)
