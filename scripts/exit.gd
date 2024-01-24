extends Node2D

@export var nextScene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	var shouldExit = true
	
	for body in $Area2D.get_overlapping_bodies():
		if body.parentConglomerate.isPlayable:
			shouldExit = false
			#print(body)
			break
		
		
	
	#print($Area2D.get_overlapping_bodies().size())
	
	#return
	if shouldExit:
		exit()
	
	pass

func exit():
	
	get_tree().change_scene_to_packed(nextScene)
	

