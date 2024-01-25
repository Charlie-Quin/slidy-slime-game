extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_just_pressed("pause"):
		setPaused(!paused)
	
	pass

var paused = false

func setPaused(value):
	
	visible = !paused
	
	paused = value
	
	get_tree().paused = value
	

func _on_resume_pressed():
	setPaused(false)
	pass # Replace with function body.


func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	pass # Replace with function body.
