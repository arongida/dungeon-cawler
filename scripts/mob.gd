class_name Mob
extends Area2D

enum State {ALIVE, DEAD}

@export var speed := 100.0
@export var damage := 10.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var wing_flap_player: AudioStreamPlayer2D = $WingFlapPlayer
@onready var main: Main = get_parent()
@onready var health_component: HealthComponent = $HealthComponent

var _state: State = State.ALIVE
var _velocity: Vector2 = Vector2.ZERO
var _player: Player
var _soundTriggered: bool = false

var exp_reward = 1

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
		animated_sprite.flip_h = _velocity.x > 0
		
		
func _process_dead(delta: float) -> void:
	if animated_sprite.frame >= 5:
		_velocity = Vector2.UP * speed
		if !_soundTriggered:
			wing_flap_player.play()
			_soundTriggered = true
		
func _updateAlpha(toValue: float):
	modulate.a = toValue	
	
	
func _updateFlash(toValue: float):
	(animated_sprite.material as ShaderMaterial).set_shader_parameter("flash_value", toValue)

func _on_area_entered(area: Area2D) -> void:
	if area is Player or area is Nut:
		health_component.hp -= area.damage * _player.damage_bonus

func _on_health_component_died() -> void:
	if _state == State.DEAD:
		return
	_state = State.DEAD
	_velocity = Vector2.ZERO
	
	if animated_sprite.animation == "walk":
		animated_sprite.play("takeoff")
	collision_shape.set_deferred("disabled", true)
	
	var flash_tween = get_tree().create_tween()
	flash_tween.tween_method(_updateFlash, 1.0, 0.0, 0.2)
	#flash_tween.tween_callback(wing_flap_player.play)
	
	var modulate_tween = get_tree().create_tween()
	modulate_tween.tween_method(_updateAlpha, 0.8, 0.1, 2)
	modulate_tween.tween_callback(queue_free)
	
	main.update_score(1, exp_reward)

func increase_power(power_coefficient: float):
	speed *= power_coefficient
	health_component.max_hp *= power_coefficient
	damage *= power_coefficient
	print("increased mob power by "+ str(power_coefficient))
	print("speed "+str(speed))
	print("health_component.maxhp "+ str(health_component.max_hp))
	print("dmg "+str(damage))
