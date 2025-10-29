class_name HealthComponent
extends Node
signal died

@export var damage_text: PackedScene

@export var max_hp := 100.0:
	set(value):
		max_hp = value
		_set_max_hp()
		
var hp := 100.0:
	set(value):
		if value <= max_hp:
			hp = value
		else:
			hp = max_hp
		_set_hp()
		
@onready var hp_bar := $HPBar

func _ready() -> void:
	hp = max_hp
	hp_bar.max_value = max_hp
	
func _set_max_hp():
	if hp_bar:
		hp_bar.max_value = max_hp

func _set_hp():
	if hp <= 0:
		died.emit()
	if hp_bar:
		hp_bar.value = hp
		if hp < max_hp:
			hp_bar.show()
			if (hp / max_hp) > 0.4:
				var tween = get_tree().create_tween()
				tween.tween_method(_update_hp_bar_alpha, 1.0, 0.0, 4)
		else:
			hp_bar.hide()

func reset_to(new_max_hp: float):
	max_hp = new_max_hp
	hp = max_hp
	
func _update_hp_bar_alpha(to_value):
	hp_bar.modulate.a = to_value
	
func take_damage(damage):
	hp -= damage
	var floating_text: DamageText = damage_text.instantiate()
	floating_text.text = str(int(damage))
	add_child(floating_text)
	floating_text.start_animation()
	
	
