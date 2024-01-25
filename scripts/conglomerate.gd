@tool

extends Node2D

signal finishedMoving

enum types {BLUE_PLAYABLE , PINK_CLOCKWISE_CIRCLE, PURPLE_COUNTERCLOCKWISE_CIRCLE, GREEN_SNAKEY, ORANGE_UPDOWN, RED_RIGHTLEFT, GREY_NULL}
@export var options : types

var _colorNum = 0

const STEPSIZE = 128
var blobs = []

enum dir {UP,DOWN,RIGHT,LEFT}
var movementPattern = []

var running = false

var isPlayable = false

func _ready():
	
	setBlobColors()
	
	match options:
		
		types.BLUE_PLAYABLE:
			isPlayable = true
		
		types.PINK_CLOCKWISE_CIRCLE:
			movementPattern = [dir.UP,dir.RIGHT,dir.DOWN,dir.LEFT]
		
		types.PURPLE_COUNTERCLOCKWISE_CIRCLE:
			movementPattern = [dir.DOWN,dir.RIGHT,dir.UP,dir.LEFT]
		
		types.GREEN_SNAKEY:
			movementPattern = [dir.RIGHT,dir.UP,dir.RIGHT,dir.DOWN,dir.LEFT,dir.UP,dir.LEFT,dir.DOWN]
		
		types.ORANGE_UPDOWN:
			movementPattern = [dir.UP,dir.DOWN]
		
		types.RED_RIGHTLEFT:
			movementPattern = [dir.LEFT,dir.RIGHT]
		
		_:
			isPlayable = false
		
	

func circleMovement():
	if movementPattern.size() == 0:
		return
	
	var direction = movementPattern.pop_front()
	movementPattern.append(direction)

func move():
	
	setBlobs()
	
	if movementPattern.size() == 0:
		return
	
	var direction = movementPattern.pop_front()
	movementPattern.append(direction)
	
	match direction:
		dir.LEFT:
			direction = Vector2.LEFT
		dir.RIGHT:
			direction = Vector2.RIGHT
		dir.UP:
			direction = Vector2.UP
		dir.DOWN:
			direction = Vector2.DOWN
		_:
			print("direction in match",direction)
	
	await moveBlobs(direction)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	
	if Engine.is_editor_hint():
		setBlobColors()
		return
	
	setBlobs()
	primeBlobsForMove()
	
	match options:
		
		types.BLUE_PLAYABLE:
			playerControl()
		
		
		#otherwise it is a grey conglomerate
		_:
			pass
		
	
	



func playerControl():
	
	if blobs.size() == 0:
		
		return
	
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
		get_tree().get_first_node_in_group("TimeKeeper").save_game()
		running = true
		moveBlobs(dir)
	
	pass



func persistUpdate():
	setBlobColors()
	
	if movementPattern.size() > 0:
		movementPattern.push_front(movementPattern.back())
		movementPattern.pop_back()
	
	

var longestLength = 0
func moveBlobs(direction):
	
	#moved up here so that blobs can change it if they need to
	longestLength = 0
	
	if blobs.size() == 0:
		return
	
	for blob in blobs:
		
		blob.scale = Vector2.ONE
		blob.fixed = false
		blob.updateCurrentlyOnWall(direction)
		
		blob.lastPos = blob.position
		
	
	
	
	while true:
		var somethingMoved = false
		
		for blob in blobs:
			
			if blob.tryMoveMeAndMyBuddies(direction):
				somethingMoved = true
			
		if !somethingMoved:
			break
	
	
	var blobSpeed = 50.0 #tiles per second
	
	for blob in blobs:
		var blobTween = get_tree().create_tween()
		
		var duration = (blob.lastPos.distance_to(blob.position) / STEPSIZE / blobSpeed)
		var delay = blob.stepsDelayBeforeMovement/blobSpeed
		longestLength = max(longestLength,duration + delay)
		
		var newPosition = blob.position
		blob.position = blob.lastPos
		
		#this line is so that tween from other conglomerates will work
		blob.lastPos = newPosition
		
		if blob.new:
			blobTween.tween_callback( blob.setColor.bind(options)).set_delay(delay)
		blobTween.tween_property(blob,"position",newPosition,duration)
		
	
	await get_tree().create_timer(longestLength).timeout
	
	if isPlayable:
		#print("------------------------")
		for conglomerate in get_tree().get_nodes_in_group("conglomerate"):
			if conglomerate == self:
				continue
			
			conglomerate.setBlobs()
			if conglomerate.blobs.size() == 0:
				conglomerate.circleMovement()
				continue
			
			#print(conglomerate.blobs.size())
			
			await get_tree().create_timer(0.05).timeout
			await conglomerate.move()
		
	
	#await get_tree().create_timer(0.1).timeout
	
	
	emit_signal("finishedMoving")
	running = false
	return
	


func setBlobs():
	blobs.clear()
	
	for child in get_children():
		blobs.append(child)
		
		

func setBlobColors():
	setBlobs()
	for blob in blobs:
		blob.setColor(options)
		

func primeBlobsForMove():
	
	for blob in blobs:
		primeBlobForMove(blob)
		
	

func primeBlobForMove(blob):
	blob.parentConglomerate = self
	blob.stepsDelayBeforeMovement = 0
	blob.stepsThisMove = 0
	blob.new = false
	#blob.setColor(myColorNum)
	
