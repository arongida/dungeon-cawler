extends Area2D

enum State {ALIVE, DEAD}

@export var speed: int = 100
@export var damage: int = 10

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var _state: State = State.ALIVE
var _velocity: Vector2 = Vector2.ZERO
var _player: Node2D

func _assign_start_position():
	var min_distance = 600.0
	var max_distance = 900.0
	var angle = randf_range(0, 2 * PI)
	var radius = randf_range(min_distance, max_distance)
	var offset = Vector2(radius, 0).rotated(angle)
	position = _player.global_position + offset

func _ready() -> void:
	_player = get_parent().find_child("Player")
	animated_sprite.play("fly")
	_assign_start_position()



func _process(delta: float) -> void:
	match _state:
		State.ALIVE:
			_process_alive(delta)
		State.DEAD:
			_process_dead(delta)
	position += _velocity * delta
	
func _process_alive(delta: float) -> void:
	if not is_instance_valid(_player):
		_velocity = Vector2.ZERO
		animated_sprite.play("idle")
		return

	var distance_to_player = global_position.distance_to(_player.global_position)
	var current_speed = speed
	if distance_to_player > 700:
		current_speed = speed * 2
		animated_sprite.play("fly")
	elif distance_to_player < 300: 
		animated_sprite.play("walk")

	var direction = global_position.direction_to(_player.global_position)
	_velocity = direction * current_speed
	
	if direction.x != 0:
		scale.x = -1 if direction.x > 0 else 1 
		
		
func _process_dead(delta: float) -> void:
	if animated_sprite.frame >= 5:
		_velocity = Vector2.UP * speed
		
func _updateAlpha(toValue: float):
	modulate.a = toValue		

func _on_area_entered(area: Area2D) -> void:
	if _state == State.DEAD:
		return
	_state = State.DEAD
	_velocity = Vector2.ZERO
	
	if animated_sprite.animation == "walk":
		animated_sprite.play("takeoff")
	collision_shape.set_deferred("disabled", true)
	
	var tween = get_tree().create_tween()
	tween.tween_method(_updateAlpha, 0.8, 0.1, 2)
	tween.tween_callback(queue_free)
	
