extends Node2D

@export var nextScene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	wait = 6
	pass # Replace with function body.

var wait = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var shouldExit = true
	
	for body in $Area2D.get_overlapping_bodies():
		if body.parentConglomerate.isPlayable:
			shouldExit = false
			break
		
	
	if wait > 0:
		
		wait -= 1
		
		if wait == 4:
			$Area2D/CollisionShape2D.disabled = true
		if wait == 2:
			$Area2D/CollisionShape2D.disabled = false
		
		shouldExit = false
		
	
	
	if shouldExit:
		exit()
	
	pass

func persistUpdate():
	
	wait = 6
	
	pass

func exit():
	
	get_tree().change_scene_to_packed(nextScene)
	

