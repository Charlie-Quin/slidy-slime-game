extends Node

signal allDone

var BLOBSPEED = 25.0

var allTweensCurrently = []

var shouldAccel = false

func accelerateTweens():
	for tween in allTweensCurrently:
		
		tween.set_speed_scale(50.0)
		
	
	
	
	
	pass

func cleanTweens():
	for tween in allTweensCurrently:
		
		tween = tween as Tween
		
		if !tween.is_valid():
			allTweensCurrently.erase(tween)
		if !tween.is_running():
			allTweensCurrently.erase(tween)
	
	if allTweensCurrently.size() == 0:
		emit_signal("allDone")
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	cleanTweens()
	
	if shouldAccel:
		accelerateTweens()
	
	
	
	pass
