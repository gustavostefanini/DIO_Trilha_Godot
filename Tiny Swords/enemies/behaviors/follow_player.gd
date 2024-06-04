extends CharacterBody2D

var speed: float = 2
var difference: Vector2
var player_position: Vector2 = Vector2(0,0)
var input_vector: Vector2

func _process(delta):
	difference = player_position - position
	input_vector = difference.normalized()
	velocity = input_vector * speed * 100
	move_and_slide()
	pass
