extends CharacterBody2D

@export var speed: float = 5

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

var is_running: bool = false


func _physics_process(delta: float):
	
	#movimento geral
	var input_vector = Input.get_vector("move_left","move_right","move_up","move_down",.15)
	var target_velocity = input_vector * speed * 100
	velocity = lerp(velocity,target_velocity,.15)
	move_and_slide()
	
	#muda animação para correr e vice-versa
	if input_vector != Vector2(0,0):
		animation_player.play("run")
		is_running = true
	else:
		animation_player.play("idle")
		is_running = false
	
	#flipa a sprite conforme direção do movimento
	if input_vector.x > 0:
		sprite.flip_h = false
	if input_vector.x < 0: 
		sprite.flip_h = true
	
	#implementa dashing com shift
	
