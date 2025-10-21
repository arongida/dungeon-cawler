extends Node
@onready var sprite: Sprite2D = $"../NutSprite2D"
@onready var nut: Nut = $".."


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (get_tree().get_frame() % 10) == 0 and nut.visible:
		var newSprite = sprite.duplicate()
		newSprite.scale *= 0.5 
		newSprite.z_index = 0
		add_child(newSprite)
		newSprite.global_position = nut.global_position + sprite.position
		newSprite.fadeOut()
