class_name Nut
extends Area2D

@export var speed = 400
@export var damage = 80

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var crack_sound_player: AudioStreamPlayer2D = $CrackSoundPlayer

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
	monitoring = false
	speed = 0
	hide()
	
	if crack_sound_player.stream:
		crack_sound_player.play()
		crack_sound_player.finished.connect(queue_free)
	else:
		queue_free()


func _on_spin_timer_timeout() -> void:
	animation_player.play("spin")
