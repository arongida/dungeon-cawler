extends Sprite2D


func _updateAlpha(toValue: float):
	modulate.a = toValue	
	
func fadeOut():
	var tween = get_tree().create_tween()
	tween.tween_method(_updateAlpha, 0.8, 0, 0.5)
	tween.tween_callback(queue_free)
