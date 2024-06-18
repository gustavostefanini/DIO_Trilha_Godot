class_name Enemy
extends Node2D

@export var health: int = 4
@export var death_prefab: PackedScene

func damage(amount: int):
	health -= amount
	if health <= 0:
		die()

func die():
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	queue_free()
