class_name Enemy
extends Node2D

@export var health: int
@export var death_prefab: PackedScene
@export var damage_amount: int
var is_dead: bool
@export var exp_amount: int

@onready var damage_digit_prefab = preload("res://misc/damage_digit.tscn")
@onready var damage_digit_marker = $Marker2D

func damage(amount: int):
	health -= amount
	
	#dica visual dano
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self,"modulate",Color.WHITE,0.3)
	
	
	#mostra dano
	var damage_digit = damage_digit_prefab.instantiate()
	damage_digit.value = amount
	if damage_digit_marker:
		damage_digit.global_position = $Marker2D.global_position
	else: 
		damage_digit.global_position = position
	get_parent().add_child(damage_digit)
	
	#processa morte
	if health <= 0:
		die()
		is_dead = true
		return is_dead

func die():
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		death_object.scale = scale
		get_parent().add_child(death_object)
	queue_free()
