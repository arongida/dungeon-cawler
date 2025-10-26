class_name Player
extends Area2D
signal died
signal leveled_up


@export var nut_scene: PackedScene

#Stats
@export var speed = 200
@export var hp = 100:
	set(value):
		hp = value
		_process_hp()

@export var projectile_count = 1
@export var experience_gain = 10.0
@export var defense = 0.0
@export var damage = 1.0
@export var cooldown_reduction: float = 0.0:
	set(value):
		cooldown_reduction = value
		_cooldown_changed()

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var nut_timer: Timer = $NutTimer


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
		
func _process_hp():
		if hp <= 0:
			_handle_dead()
		Globals.hud.update_hp(hp)

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
		var flyPressed = Input.is_action_pressed("fly")
		var currentSpeed = speed

		if flyPressed: 
			currentSpeed *= 2
			nut_timer.stop()
		elif nut_timer.is_stopped() and visible:
			nut_timer.start()
			

		if velocity.x != 0:
			if flyPressed: 
				animated_sprite.play("fly")
			else: 
				animated_sprite.play("walk")
			scale.x = -1 if velocity.x > 0 else 1

		elif velocity.y != 0:
			if flyPressed: 
				animated_sprite.play("fly")
			else: 
				animated_sprite.play("walk")
		else:
			animated_sprite.play("idle")
			
		velocity = velocity.normalized() * currentSpeed
		position += velocity * delta
		position.x = clamp(position.x, -12500, 12000)
		position.y = clamp(position.y, -7000, 8000)
	
func start(pos):
	position = pos
	hp = 100
	show()
	collision_shape.disabled = false

func combat_start():
	nut_timer.start()

func _updateFlash(toValue: float):
	(animated_sprite.material as ShaderMaterial).set_shader_parameter("flash_value", toValue)

func _on_area_entered(area: Area2D) -> void:		
	var flash_tween: Tween = get_tree().create_tween()
	flash_tween.tween_method(_updateFlash, 1.0, 0.0, 0.2)
	var damage = area.damage * (100 / (100 + defense))
	hp -= damage

func level_up():
	level += 1
	leveled_up.emit()
	

func _on_nut_timer_timeout() -> void:
	var nut = nut_scene.instantiate()
	nut.position = position
	get_parent().add_child(nut)
