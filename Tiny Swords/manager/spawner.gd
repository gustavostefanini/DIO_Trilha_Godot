extends Node2D

@export var creatures: Array[PackedScene]

@onready var path_follow: PathFollow2D = $Path2D/PathFollow2D

var spawn_cooldown: float = 0
var creature_selector: int

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	#freq
	spawn_cooldown -= delta
	if spawn_cooldown > 0: return
	creature_selector = randi_range(0,creatures.size()-1)
	var creature = creatures[creature_selector].instantiate()
	creature.position = get_point()
	get_parent().add_child(creature)
	spawn_cooldown = 2.0

func get_point():
	path_follow.progress_ratio = randf()
	return path_follow.position
