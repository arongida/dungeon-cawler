extends Node2D

@export var mob_scene: PackedScene

@onready var hud: HUD = $HUD
@onready var player: Player = $Player
@onready var mob_timer: Timer = $MobTimer
@onready var start_position: Marker2D = $StartPosition
@onready var start_timer: Timer = $StartTimer

var _score

func _on_player_hit() -> void:
	var hp = player.hp
	hud.update_hp(hp)
	update_score()
	if hp <= 0:
		game_over()
	
func game_over():
	mob_timer.stop()
	hud.show_game_over()
	_clean_up()
	
func new_game():
	_clean_up()
	_score = 0
	player.start(start_position.position)
	hud.update_score(_score)
	hud.update_hp(player.hp)
	hud.show_message("Get Ready!")
	start_timer.start()
	

func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()
	add_child(mob)

func _on_start_timer_timeout() -> void:
	mob_timer.start()
	player.combat_start()


func _on_hud_start_game() -> void:
	new_game()
	
func update_score():
	_score += 1
	hud.update_score(_score)
	if _score % 10 == 0:
		player.level_up()
		hud.update_hp(player.hp)
		hud.show_lvl(player.level)
		mob_timer.wait_time -= 0.02
	
func _clean_up():
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("projectiles", "queue_free")
