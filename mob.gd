extends Area2D

enum State {WALK, TAKEOFF}

@export var speed: int = 100
@export var damage: int = 10

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var _state: State = State.WALK
var _velocity: Vector2 = Vector2.ZERO
var _player: Node2D

func _ready() -> void:
	_player = get_parent().find_child("Player")
	animated_sprite.play("walk")

func _process(delta: float) -> void:
	match _state:
		State.WALK:
			_process_walk(delta)
		State.TAKEOFF:
			_process_takeoff(delta)
	position += _velocity * delta
	
func _process_walk(delta: float) -> void:
	if not is_instance_valid(_player):
		_velocity = Vector2.ZERO
		animated_sprite.play("idle")
		return
	var direction = global_position.direction_to(_player.global_position)
	_velocity = direction * speed
	
	if direction.x != 0:
		scale.x = -1 if direction.x > 0 else 1 
		
func _process_takeoff(delta: float) -> void:
	if animated_sprite.animation == "takeoff" and animated_sprite.frame >= 5:
		_velocity = Vector2.UP * speed
		
func _on_area_entered(area: Area2D) -> void:
	if _state == State.TAKEOFF:
		return
	_state = State.TAKEOFF
	_velocity = Vector2.ZERO
	
	animated_sprite.play("takeoff")
	collision_shape.set_deferred("disabled", true)
	
	modulate.a = 0.5
	
	await get_tree().create_timer(2.0).timeout
	queue_free()
