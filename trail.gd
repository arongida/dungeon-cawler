extends Node
@onready var sprite: Sprite2D = $"../NutSprite2D"
@onready var nut: Area2D = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#if (get_tree().get_frame() % 3) == 0:
		#var newSprite = sprite.duplicate()
		#newSprite.z_index = 0
		#get_tree().root.add_child(newSprite)
		#newSprite.global_position = nut.global_position + sprite.position
		#newSprite.fadeOut()
