extends Sprite2D

@export var speed = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Hello World from Player!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	position += input * speed * delta
