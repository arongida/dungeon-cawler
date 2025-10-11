extends Area2D
signal enemy_hit

@export var speed = 400
var target = null

func _ready() -> void:
	var mobs = get_tree().get_nodes_in_group("mobs")
	var closest_mob = null
	var min_dist = 100000
	for mob in mobs:
		var dist = global_position.distance_to(mob.global_position)
		if dist < min_dist:
			min_dist = dist
			closest_mob = mob
	target = closest_mob
	if target != null:
		look_at(target.global_position)


func _process(delta: float) -> void:
		var forward = Vector2.RIGHT.rotated(rotation)
		position += forward * speed * delta


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("mobs"):
		area.queue_free()
		get_parent().update_score()
	queue_free()
