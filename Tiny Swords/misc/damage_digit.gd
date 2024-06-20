extends Node2D

@export var value: int

func _ready():
	%DamageDigit.text = str(value)
