extends CharacterBody2D



@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

var is_running: bool = false
var is_dashing: bool = false
var dash_time: float = 0.0
@export var dash_maximum_time: float = .2
@export var dash_speed: float = 15
@export var normal_speed: float = 5
var speed = normal_speed

func _physics_process(delta: float):
	
	#movimento geral
	var input_vector = Input.get_vector("move_left","move_right","move_up","move_down",.15)
	var target_velocity = input_vector * speed * 100
	velocity = lerp(velocity,target_velocity,.15)
	move_and_slide()
	
	#muda animação para correr e vice-versa
	if input_vector != Vector2(0,0):
		if not is_dashing:
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
	if is_running and Input.is_action_just_pressed("dash"):
		is_dashing = true
		speed = dash_speed
		animation_player.play("dashing")
	if is_dashing:
		dash_time += delta
		if dash_time >= dash_maximum_time:
			is_dashing = false
			speed = normal_speed
			dash_time = 0.0
			animation_player.play("idle")
			
		
		
