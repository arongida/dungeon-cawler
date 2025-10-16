class_name HUD
extends CanvasLayer

signal start_game

@onready var score_label: Label = $ScoreLabel
@onready var message_label: Label = $MessageLabel
@onready var start_button: Button = $StartButton
@onready var message_timer: Timer = $MessageTimer
@onready var hp_label: Label = $HPLabel

func show_message(text):
	message_label.text = text
	message_label.show()
	message_timer.start()
	
func show_game_over():
	show_message("Game Over")
	await message_timer.timeout
	
	message_label.text = "Caw caw!"
	message_label.show()
	
	await get_tree().create_timer(1.0).timeout
	start_button.show()
	
func update_score(score):
	score_label.text = str(score)


func _on_start_button_pressed() -> void:
	start_button.hide()
	start_game.emit()


func _on_message_timer_timeout() -> void:
	message_label.hide()
	
func update_hp(hp):
	hp_label.text = "HP: " + str(hp)
