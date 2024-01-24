@tool

extends Node2D

enum types {BLUE_PLAYABLE , PINK_CLOCKWISE_CIRCLE, PURPLE_COUNTERCLOCKWISE_CIRCLE, GREEN_SNAKEY, ORANGE_UPDOWN, RED_RIGHTLEFT, GREY_NULL}
@export var options : types

var _colorNum = 0

const STEPSIZE = 128
var blobs = []

var running = false

var isPlayable = false

func _ready():
	
	setBlobColors()
	
	match options:
		
		types.BLUE_PLAYABLE:
			isPlayable = true
		
		_:
			isPlayable = false
		
	

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
		
	
	
	
	while true:
		var somethingMoved = false
		
		for blob in blobs:
			
			if blob.tryMoveMeAndMyBuddies(direction):
				somethingMoved = true
			
		
		if !somethingMoved:
			break
	
	var longestLength = 0
	var blobSpeed = 50.0 #tiles per second
	
	for blob in blobs:
		var blobTween = get_tree().create_tween()
		
		var duration = (blob.lastPos.distance_to(blob.position) / STEPSIZE / blobSpeed)
		var delay = blob.stepsDelayBeforeMovement/blobSpeed
		longestLength = max(longestLength,duration + delay)
		
		var newPosition = blob.position
		blob.position = blob.lastPos
		
		if blob.new:
			blobTween.tween_callback( blob.setColor.bind(options)).set_delay(delay)
		blobTween.tween_property(blob,"position",newPosition,duration)
		
	
	await get_tree().create_timer(longestLength).timeout
	
	
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
	
