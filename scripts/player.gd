class_name Player
extends Area2D
signal hit
@export var nut_scene: PackedScene
@export var speed = 400
@export var hp = 100

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var flash_animation: AnimationPlayer = $FlashAnimation
@onready var nut_timer: Timer = $NutTimer

#var _screen_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#_screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_process_movement(delta)
	if hp <= 0:
		_handle_dead()
		

func _handle_dead():
		hide()
		collision_shape.set_deferred("disabled", true)
		nut_timer.stop()

func _process_movement(delta: float):
		var velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		velocity = velocity.normalized() * speed
			
		position += velocity * delta
		#position = position.clamp(Vector2.ZERO, _screen_size)
		
		if velocity.x != 0:
			animated_sprite.play("walk")
			scale.x = -1 if velocity.x > 0 else 1
		elif velocity.y != 0:
			animated_sprite.play("walk")
		else:
			animated_sprite.play("idle")
	
func start(pos):
	position = pos
	hp = 100
	show()
	collision_shape.disabled = false

func combat_start():
	nut_timer.start()


func _on_area_entered(area: Area2D) -> void:
	flash_animation.play("flash")
	hp -= area.damage
	hit.emit()


func _on_nut_timer_timeout() -> void:
	var nut = nut_scene.instantiate()
	nut.position = position
	get_parent().add_child(nut)
