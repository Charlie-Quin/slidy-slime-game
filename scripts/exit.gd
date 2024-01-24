extends Node2D

@export var nextScene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var wait = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if wait > 0:
		wait -= 1
		return
	
	var shouldExit = true
	
	for body in $Area2D.get_overlapping_bodies():
		if body.parentConglomerate.isPlayable:
			shouldExit = false
			#print(body)
			break
		
		
	
	#print($Area2D.get_overlapping_bodies().size())
	if shouldExit:
		exit()
	
	pass

func persistUpdate():
	
	wait = 6
	
	pass

func exit():
	
	get_tree().change_scene_to_packed(nextScene)
	

