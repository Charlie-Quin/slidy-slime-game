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
	
	#compress
	while true:
		var somethingMoved = false
		
		for blob in blobs:
			blob.scale = Vector2.ONE
			if await blob.tryMove(direction):
				somethingMoved = true
		if !somethingMoved:
			break
		
	
	#decompress
	while true:
		var somethingMoved = false
		
		for blob in blobs:
			
			if await blob.stepBackIfOverlapping():
				somethingMoved = true
			
		
		if !somethingMoved:
			break
	
	var leastMovedBlob = findNegativeDirectionMostBlobThatIsTouchingWall(direction)
	var currentFocusBlob = leastMovedBlob
	#fix everything to the right
	while true:
		var rightBlobs = getBlobsRelativeToBlob(direction,currentFocusBlob,true)
		
		if rightBlobs.size() == 0:
			break
		
		while true:
			if checkIfAnyBlobIsTouching(rightBlobs,currentFocusBlob):
				for blob in rightBlobs:
					if blob.currentlyTouchingWall:
						currentFocusBlob = blob
				break
			for blob in rightBlobs:
				await blob.stepBack()
			
	
	#fix to the left
	currentFocusBlob = leastMovedBlob
	while true:
		var leftBlobs = getBlobsRelativeToBlob(direction,currentFocusBlob,false)
		
		if leftBlobs.size() == 0:
			break
		
		while true:
			if checkIfAnyBlobIsTouching(leftBlobs,currentFocusBlob):
				for blob in leftBlobs:
					if blob.currentlyTouchingWall:
						currentFocusBlob = blob
				break
			for blob in leftBlobs:
				await blob.stepBack()
			
	
	running = false
	



func checkIfAnyBlobIsTouching(inputBlobs,targetBlob):
	
	for blob in inputBlobs:
		
		if blob.position.distance_to(targetBlob.position) < STEPSIZE * 1.5:
			return true
		
	
	return false
	

func getBlobsRelativeToBlob( direction,inputBlob,right):
	
	var returnBlobs = []
	
	if direction == Vector2.UP or direction == Vector2.DOWN:
		var desiredX = inputBlob.position.x + STEPSIZE if right else inputBlob.position.x - STEPSIZE
		
		for blob in blobs:
			if is_equal_approx(blob.position.x,desiredX):
				returnBlobs.append(blob)
	else:
		var desiredY = inputBlob.position.y + STEPSIZE if right else inputBlob.position.y - STEPSIZE
		
		for blob in blobs:
			if is_equal_approx(blob.position.y,desiredY):
				returnBlobs.append(blob)
	
	
	return returnBlobs
	pass

func findNegativeDirectionMostBlobThatIsTouchingWall(direction):
	
	var best = null
	var bestBlob = null
	
	if direction == Vector2.RIGHT:
		for blob in blobs:
			
			if blob.currentlyTouchingWall == false:
				continue
			
			pass
			
			if best == null or blob.position.x < best:
				best = blob.position.x
				bestBlob = blob
	if direction == Vector2.LEFT:
		for blob in blobs:
			if blob.currentlyTouchingWall == false:
				continue
			
			if best == null or blob.position.x > best:
				best = blob.position.x
				bestBlob = blob
	if direction == Vector2.UP:
		for blob in blobs:
			if blob.currentlyTouchingWall == false:
				continue
			
			if best == null or blob.position.y > best:
				best = blob.position.y
				bestBlob = blob
	if direction == Vector2.DOWN:
		for blob in blobs:
			if blob.currentlyTouchingWall == false:
				continue
			
			if best == null or blob.position.y < best:
				best = blob.position.y
				bestBlob = blob
	
	return bestBlob
	
	pass

func checkIfBlobStateIsValid():
	
	for blob in blobs:
		if !blob.checkIfPositionIsValid():
			return false;
	
	return true
	
	
	pass

func setBlobs():
	blobs.clear()
	
	for child in get_children():
		blobs.append(child)
		child.parentConglomerate = self
	
	
	
	
