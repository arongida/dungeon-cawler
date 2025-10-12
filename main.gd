extends Node2D
@export var mob_scene: PackedScene
var score




func _on_player_hit() -> void:
	var hp = $Player.hp
	$HUD.update_hp(hp)
	if hp <= 0:
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
