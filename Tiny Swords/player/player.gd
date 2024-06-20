class_name Player
extends CharacterBody2D
	 
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var sword_area: Area2D = $SwordArea
@onready var hit_area: Area2D = $HitArea
@onready var hit_points_progress: ProgressBar = $HitPointsProgressBar

#variáveis de hit points
@export var hit_points: int
@export var max_hit_points: int
@export var death_prefab: PackedScene

#varíavel para dano
@export var sword_damage: int
var actual_damage: int

#variável para leitura do teclado
var input_vector: Vector2
var attack_direction: String

#velocidades
var normal_speed: float = 5
var attack_speed: float = 2
var dash_speed: float = 15
@export var speed = normal_speed

#declarações de ação
var is_running: bool = false
var is_dashing: bool = false
var is_attacking: bool = false

#tempos de cooldown
var dash_maximum_time: float = .2
var attack_maximum_time: float = 0.6
var attack_time: float = 0
var dash_time: float = 0
var hit_area_cooldown: float = 0.0

func _process(delta: float):
	
	#passa a posição do player para o manager
	GameManager.player_position = position
	
	#lê teclas de ação e chama suas funções
	read_input()
	
	#processar dano
	update_hit_area(delta)
	
	#atualizar barra de vida
	hit_points_progress.max_value = max_hit_points
	hit_points_progress.value = hit_points
	
	#configura cooldown dos ataques
	if is_attacking:
		attack_time += delta
		if attack_time >= attack_maximum_time:
			is_attacking = false
			speed = normal_speed
			attack_time = 0.0
			animation_player.play("idle")
	
	#configura cooldown do dash
	if is_dashing:
		dash_time += delta
		if dash_time >= dash_maximum_time:
			is_dashing = false
			speed = normal_speed
			dash_time = 0
			animation_player.play("idle")
	
	#configura animação para correr e respirar
	if not is_attacking:
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
	


func read_input():
	
	#movement
	input_vector = Input.get_vector("move_left","move_right","move_up","move_down",.15)
	move()
	
	#attack
	if Input.is_action_just_pressed("attack_1") and not is_dashing:
		attack("1")
	if Input.is_action_just_pressed("attack_2") and not is_dashing:
		attack("2")
		
	#dash
	if is_running and Input.is_action_just_pressed("dash"):
		dash()

func move():
	var target_velocity = input_vector * speed * 100.0
	velocity = lerp(velocity,target_velocity,.15)
	move_and_slide()

func attack(attack_type: String):
	if is_attacking:
		return
	is_attacking = true
	speed = attack_speed
	actual_damage = sword_damage * attack_type.to_int()
	if input_vector.x !=  0 or input_vector == Vector2(0,0):
		attack_direction = "attack_side_"
	elif input_vector.y < 0:
		attack_direction = "attack_up_"
	elif input_vector.y > 0:
		attack_direction = "attack_down_"
	animation_player.play(attack_direction + attack_type) 

func dash():
	if is_dashing:
		return
	is_dashing = true
	speed = dash_speed
	animation_player.play("dashing")

func dano_a_inimigos():
	var bodies = sword_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			var enemy_direction = (enemy.position - position).normalized()
			var attack_vector: Vector2
			if attack_direction == "attack_side_":
				if sprite.flip_h:
					attack_vector = Vector2.LEFT
				else:
					attack_vector = Vector2.RIGHT
			elif attack_direction == "attack_up_":
				attack_vector = Vector2.UP
			elif attack_direction == "attack_down_":
				attack_vector = Vector2.DOWN
			var dot_product = enemy_direction.dot(attack_vector)
			if dot_product > .45 :
				enemy.damage(actual_damage)

func update_hit_area(delta: float):
	#temporizador
	hit_area_cooldown -= delta
	if hit_area_cooldown > 0: return
	
	#frequencia
	hit_area_cooldown = 0.5
	
	var bodies = hit_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			var damage_amount = enemy.damage_amount
			damage(damage_amount)

func damage(amount: int):
	if hit_points <= 0:
		return
	
	hit_points -= amount
	print("o player está com ",hit_points," de vida")
	
	#dica visual do hit
	modulate = Color.YELLOW_GREEN
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self,"modulate",Color.WHITE,0.3)
	#processa caso de morte
	if hit_points <= 0:
		die()

func die():
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		death_object.scale = scale
		get_parent().add_child(death_object)
	queue_free()

func regen(amount: int):
	hit_points += amount
	if hit_points > max_hit_points:
		hit_points = max_hit_points
	return hit_points
