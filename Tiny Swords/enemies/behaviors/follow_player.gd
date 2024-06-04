extends CharacterBody2D

var speed: float = 2

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
func _process(delta):
	
	#movimenta seguindo a posição do player
	var player_position = GameManager.player_position
	var difference = player_position - position
	var input_vector = difference.normalized()
	velocity = input_vector * speed * 100
	move_and_slide()
	
	#inverte a animação conforme o movimento
	if input_vector.x > 0:
			sprite.flip_h = false
	if input_vector.x < 0: 
			sprite.flip_h = true
	
	
