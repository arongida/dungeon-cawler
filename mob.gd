extends Area2D

var screen_size
@export var speed = 100
@export var damage = 10

var leaving = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.animation = "idle"
	$AnimatedSprite2D.play()
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if leaving:
		var velocity = Vector2.ZERO
		velocity.y -= 1
		velocity = velocity.normalized() * speed
		position += velocity * delta
		
	else:
		var player = get_parent().get_node("Player")
		if not player:
			return
		var velocity = (player.position - position).normalized() * speed
		
		position += velocity * delta
		
		if velocity.length() > 0.1:
			$AnimatedSprite2D.animation = "walk"
			scale.x = -1 if velocity.x > 0 else 1
		else:
			$AnimatedSprite2D.animation = "idle"

	

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	leaving = true
	$AnimatedSprite2D.self_modulate = Color(1,1,1,0.5)
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite2D.animation = "takeoff"
	await get_tree().create_timer(2.0).timeout
	queue_free()
