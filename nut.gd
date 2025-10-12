extends Area2D

@export var speed = 400
var target = null

func _ready() -> void:
	var mobs = get_tree().get_nodes_in_group("mobs")
	target = mobs.pick_random()
	if target != null:
		look_at(target.global_position)


func _process(delta: float) -> void:
	position += Vector2.RIGHT.rotated(rotation) * speed * delta


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("mobs"):
		#area.queue_free()
		get_parent().update_score()
	queue_free()
