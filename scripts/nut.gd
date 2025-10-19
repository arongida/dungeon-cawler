extends Area2D

@export var speed = 400

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var _target = null

func _ready() -> void:
	animation_player.play("spin")
	var mobs = get_tree().get_nodes_in_group("mobs")
	_target = mobs.pick_random()
	if _target != null:
		look_at(_target.global_position)


func _process(delta: float) -> void:
	position += Vector2.RIGHT.rotated(rotation) * speed * delta


func _on_area_entered(area: Area2D) -> void:
	queue_free()


func _on_spin_timer_timeout() -> void:
	animation_player.play("spin")
