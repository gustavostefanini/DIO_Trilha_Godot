extends Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var exp = GameManager.player_exp
	set_text(str(exp," exp"))
