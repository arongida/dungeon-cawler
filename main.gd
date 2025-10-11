extends Node2D
@export var mob_scene: PackedScene
var score


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_hit() -> void:
	game_over()
	
func game_over():
	$MobTimer.stop()
	$Player/NutTimer.stop()
	$HUD.show_game_over()
	get_tree().call_group("mobs", "queue_free")
	
func new_game():
	get_tree().call_group("mobs", "queue_free")
	score = 0
	$Player.start($StartPosition.position)
	$HUD.update_score(score)
	$HUD.show_message("Get Ready!")
	$StartTimer.start()


func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()
	
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	mob.position = mob_spawn_location.position
	add_child(mob)

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$Player/NutTimer.start()


func _on_hud_start_game() -> void:
	new_game()
	
func update_score():
	score += 1
	$HUD.update_score(score)
