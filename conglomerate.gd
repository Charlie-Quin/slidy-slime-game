extends Node2D

const STEPSIZE = 32
var blobs = []

var running = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	setBlobs()
	
	var dir = Vector2.ZERO
	
	if Input.is_action_just_pressed("down"):
		dir = Vector2.DOWN
	elif Input.is_action_just_pressed("up"):
		dir = Vector2.UP
	elif Input.is_action_just_pressed("right"):
		dir = Vector2.RIGHT
	elif Input.is_action_just_pressed("left"):
		dir = Vector2.LEFT
	
	if dir != Vector2.ZERO and !running:
		running = true
		moveBlobs(dir)
	
	pass


func moveBlobs(direction):
	
	for blob in blobs:
		
		blob.scale = Vector2.ONE
		blob.fixed = false
		blob.updateCurrentlyOnWall(direction)
		
		blob.lastPos = blob.position
		
	
	
	print("finished moving buddies")
	
	while true:
		var somethingMoved = false
		
		for blob in blobs:
			
			if blob.tryMoveMeAndMyBuddies(direction):
				somethingMoved = true
			
		
		if !somethingMoved:
			break
	
	var longestLength = 0
	var blobSpeed = 50 #tiles per second
	
	for blob in blobs:
		var blobTween = get_tree().create_tween()
		
		var duration = (blob.lastPos.distance_to(blob.position) / STEPSIZE / blobSpeed)
		longestLength = max(longestLength,duration)
		blobTween.tween_property(blob,"position",blob.position,duration).from(blob.lastPos)
		
	
	await get_tree().create_timer(longestLength).timeout
	
	
	running = false
	return
	


func setBlobs():
	blobs.clear()
	
	for child in get_children():
		blobs.append(child)
		child.parentConglomerate = self
	
	
	
	
