extends Area2D

var player
var screen_size
@export var speed = 100
@export var damage = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.animation = "idle"
	$AnimatedSprite2D.play()
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
	queue_free()
