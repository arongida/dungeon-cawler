class_name Player
extends Area2D
signal died
signal leveled_up


@export var nut_scene: PackedScene

#Stats
@export var speed = 200
@export var projectile_count := 1.5
@export var experience_gain := 2.0
@export var defense := 0.0
@export var damage := 80
@export var damage_bonus := 1.0
@export var cooldown_reduction := 0.0:
	set(value):
		cooldown_reduction = value
		_cooldown_changed()

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var nut_timer: Timer = $NutTimer
@onready var hp_bar: ProgressBar = $HPBar
@onready var health_component: HealthComponent = $HealthComponent
@onready var caw_player: AudioStreamPlayer2D = $CawStreamPlayer


var level: int     = 1
var exp_value: int = 0:
	set(value):
		exp_value = value
		_process_exp()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#_screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_process_movement(delta)


		
func _process_exp():
	if exp_value >= level * 20:
		exp_value = 0
		level_up()
		

func _cooldown_changed():
	for node in get_tree().get_nodes_in_group("timers"):
		var timer := node as Timer
		if timer:
			timer.wait_time = 100 / (100 + cooldown_reduction)
	
func _handle_dead():
		hide()
		collision_shape.set_deferred("disabled", true)
		nut_timer.stop()
		died.emit()

func _process_movement(delta: float):
		var velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		var fly_pressed = Input.is_action_pressed("fly")
		var current_speed = speed

		if fly_pressed: 
			current_speed *= 2
			nut_timer.stop()
		elif nut_timer.is_stopped() and visible:
			nut_timer.start()
			

		if velocity.x != 0:
			if fly_pressed: 
				animated_sprite.play("fly")
			else: 
				animated_sprite.play("walk")
			animated_sprite.flip_h = velocity.x > 0

		elif velocity.y != 0:
			if fly_pressed: 
				animated_sprite.play("fly")
			else: 
				animated_sprite.play("walk")
		else:
			animated_sprite.play("idle")
			
		velocity = velocity.normalized() * current_speed
		position += velocity * delta
		position.x = clamp(position.x, -12500, 12000)
		position.y = clamp(position.y, -7000, 8000)
	
func start(pos):
	_reset_player_stats()
	position = pos
	health_component.reset_to(100)
	Globals.hud.update_hp(100)
	show()
	collision_shape.disabled = false

func combat_start():
	nut_timer.start()

func _updateFlash(toValue: float):
	(animated_sprite.material as ShaderMaterial).set_shader_parameter("flash_value", toValue)

func _on_area_entered(area: Area2D) -> void:	
	caw_player.play()
	var flash_tween: Tween = get_tree().create_tween()
	flash_tween.tween_method(_updateFlash, 1.0, 0.0, 0.2)
	var damage = area.damage * (100 / (100 + defense))
	health_component.take_damage(damage)
	Globals.hud.update_hp(health_component.hp)

func level_up():
	level += 1
	leveled_up.emit()
	

func _on_nut_timer_timeout() -> void:
	var guaranteed_projectiles = floor(projectile_count)
	for i in range(guaranteed_projectiles):
		var nut = nut_scene.instantiate()
		nut.position = position
		get_parent().add_child(nut)

	var fractional_part = projectile_count - guaranteed_projectiles
	if fractional_part > 0.0 and randf() < fractional_part:
		var nut = nut_scene.instantiate()
		nut.position = position
		get_parent().add_child(nut)


func _on_health_component_died() -> void:
	_handle_dead()
	
func _reset_player_stats():
	speed = 200
	projectile_count = 1.5
	experience_gain = 2.0
	defense = 0.0
	damage = 80
	damage_bonus = 1.0
	cooldown_reduction = 0.0
	level = 1
	exp_value = 0
	
