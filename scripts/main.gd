class_name Main
extends Node2D

@export var mob_scene: PackedScene

@onready var hud: HUD = $HUD
@onready var player: Player = $Player
@onready var mob_timer: Timer = $MobTimer
@onready var start_position: Marker2D = $StartPosition
@onready var start_timer: Timer = $StartTimer
@onready var music_player: ThemeMusicPlayer = $ThemeMusicPlayer

var _score

func _on_player_died() -> void:
	game_over()
	
	
func game_over():
	mob_timer.stop()
	music_player.fadeOut()
	hud.show_game_over()
	_clean_up()
	
func new_game():
	_clean_up()
	_score = 0
	music_player.fadeIn()
	player.start(start_position.position)
	hud.update_score(_score)
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
	
func update_score(score: int, exp: int):
	_score += score
	hud.update_score(_score)
	player.exp_value += exp * player.experience_gain
	hud.update_exp_bar(player.exp_value, player.level * 20)


func _clean_up():
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("projectiles", "queue_free")


func _on_player_leveled_up() -> void:
	get_tree().paused = true
	hud.show_lvl(player.level)
	mob_timer.wait_time -= 0.02
	hud.show_level_up_menu(true)


func _on_hud_item_selected(index: int) -> void:
	if index == 0:
		player.hp += 15
	elif index == 1:
		player.speed += 20
	elif index == 2:
		player.cooldown_reduction += 10
	elif index == 3:
		player.defense += 10
	hud.show_level_up_menu(false)
	get_tree().paused = false
