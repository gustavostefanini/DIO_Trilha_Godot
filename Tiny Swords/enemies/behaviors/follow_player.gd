extends Node

@export var speed: float = 1

var enemy: Enemy
var sprite: AnimatedSprite2D


func _ready():
	enemy = get_parent()
	sprite = enemy.get_node("AnimatedSprite2D")

func _process(delta):
	
	#movimenta seguindo a posição do player
	var player_position = GameManager.player_position
	var difference = player_position - enemy.position
	var input_vector = difference.normalized()
	enemy.velocity = input_vector * speed * 100
	enemy.move_and_slide()
	
	#inverte a animação conforme o movimento
	if input_vector.x > 0:
			sprite.flip_h = false
	if input_vector.x < 0: 
			sprite.flip_h = true
	
	
