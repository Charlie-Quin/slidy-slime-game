extends Node2D

@export var nextScene : String

var normal = Vector2.ZERO
var planePos = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$AnimationPlayer.play("point")
	
	normal = Vector2.LEFT.rotated(rotation)
	planePos = position + (normal * -128 * 2)
	
	wait = 7
	pass # Replace with function body.

var wait = 6

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var shouldExit = true
	var canExit = false
	
	for body in get_tree().get_nodes_in_group("blob"):
		
		if body.parentConglomerate.running or body.dying:
			shouldExit = false
			canExit = false
		
		#check if there is at least one blob on the other side.
		if normal.dot(body.position - planePos) < 0:
			if body.parentConglomerate.isPlayable:
				canExit = true
			continue
		
		#doesn't let you go if any blobs are left behind
		#if body.parentConglomerate.isPlayable and body.alive:
			#shouldExit = false
			#break
		
	
	#print("unaltered",shouldExit)
	
	if wait > 0:
		
		wait -= 1
		shouldExit = false
		
	
	#print(shouldExit)
	
	#return
	if shouldExit and canExit:
		exit()
	
	pass

func persistUpdate():
	
	wait = 6
	
	pass

var exited = false

func exit():
	
	if exited:
		return
	
	exited = true
	%ui.changeScene(nextScene)
	

