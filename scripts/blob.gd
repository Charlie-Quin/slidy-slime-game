@tool

extends StaticBody2D

class_name blobClass

var fixed = false

const STEPSIZE = 128
const DEBUG = false
const DEBUGTIME = 0.05
var parentConglomerate

var stepsDelayBeforeMovement = 0
var stepsThisMove = 0
var new = false

var alive = true
var dying = false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if Engine.is_editor_hint():
		return
	
	$AnimationPlayer.play("idle",0,randf_range(0.3,0.45))
	$AnimationPlayer.advance(randf())
	
	lastPos = position
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Engine.is_editor_hint():
		return
	
	pass
	

var lastPos = Vector2.ZERO
var currentlyTouchingWall = false
var currentlyTouchingBlob = false

var otherBlobInFront = null

var blobInFront = null
var blobBehind = null


func updateCurrentlyOnWall(direction):
	
	var raycast = $wallcast as RayCast2D
	raycast.global_position = global_position
	raycast.target_position = direction * STEPSIZE 
	raycast.force_raycast_update()
	currentlyTouchingWall = raycast.is_colliding()
	
	blobInFront = getBlobInPosition(position + direction * STEPSIZE)
	blobBehind = getBlobInPosition(position + direction * -STEPSIZE)
	
	raycast = $blobcast as RayCast2D
	raycast.global_position = global_position
	raycast.target_position = direction * STEPSIZE 
	raycast.force_raycast_update()
	currentlyTouchingBlob = raycast.is_colliding()
	otherBlobInFront = raycast.get_collider()
	
	blobInFront = getBlobInPosition(position + direction * STEPSIZE)
	blobBehind = getBlobInPosition(position + direction * -STEPSIZE)
	

func checkIfShouldDie():
	
	var raycast = $hazardCast as RayCast2D
	raycast.force_raycast_update()
	
	if raycast.is_colliding():
		
		
		
		var blobTween = get_tree().create_tween()
		var blobSpeed = Globals.BLOBSPEED;
		
		var duration = (lastPos.distance_to(position) / STEPSIZE / blobSpeed)
		var delay = stepsDelayBeforeMovement/blobSpeed
		var popTime = 0.3
		
		parentConglomerate.longestLength = max(parentConglomerate.longestLength,duration + delay + popTime)
		
		var newPosition = position
		position = lastPos
		
		#this line is so that tween from other conglomerates will work
		lastPos = newPosition
		
		if new:
			blobTween.tween_callback( setColor.bind(parentConglomerate.options)).set_delay(delay)
		blobTween.tween_property(self,"position",newPosition,duration)
		
		
		blobTween.tween_property(self,"modulate",Color(1,1,1,0),popTime)
		blobTween.set_parallel(true).tween_property(self,"scale",Vector2.ONE * 3.0,popTime)
		blobTween.set_parallel(false).tween_property(self,"dying",false,0)
		
		Globals.allTweensCurrently.append(blobTween)
		
		var newParent = get_parent().get_parent()
		
		get_parent().remove_child(self)
		parentConglomerate.setBlobs()
		
		newParent.add_child(self)
		
		alive = false
		dying = true
		$CollisionShape2D.disabled = true
		
		
	
	
	pass

#this function can fix blobs.
func tryMoveMeAndMyBuddies(direction):
	
	var buddies = [self]
	var currentBlob = self
	
	
	currentBlob.updateCurrentlyOnWall(direction)
	while currentBlob.blobInFront != null:
		buddies.append(currentBlob.blobInFront)
		currentBlob = currentBlob.blobInFront
		currentBlob.updateCurrentlyOnWall(direction)
	
	if currentBlob.currentlyTouchingBlob and currentBlob.otherBlobInFront != null and currentBlob.otherBlobInFront.parentConglomerate != parentConglomerate:
		
		parentConglomerate.primeBlobForMove(currentBlob.otherBlobInFront)
		
		currentBlob.otherBlobInFront.changeAlliegience(parentConglomerate)
		currentBlob.otherBlobInFront.stepsDelayBeforeMovement = stepsThisMove
		#steps this move is only used for calculating tween durations
		currentBlob.otherBlobInFront.stepsThisMove = stepsThisMove
		currentBlob.otherBlobInFront.new = true
		
		currentBlob.otherBlobInFront.fixed = false
		
		#print(stepsThisMove)
		return false
		
	
	currentBlob = self
	while currentBlob.blobBehind != null:
		buddies.append(currentBlob.blobBehind)
		currentBlob = currentBlob.blobBehind
		currentBlob.updateCurrentlyOnWall(direction)
	
	
	
	var cannotMove = false
	for buddy in buddies:
		buddy.updateCurrentlyOnWall(direction)
		if buddy.currentlyTouchingWall:
			cannotMove = true
			buddy.fixed = true
		if buddy.fixed:
			cannotMove = true
	
	if cannotMove:
		return false
	
	var startedNearFixed = false
	var fixedsWeStartedNear = []
	
	var startedNearAnything = false
	var anythingWeStartedNear = []
	
	for blob in getAllBlobsConnectedToSelf():
		startedNearAnything = true
		anythingWeStartedNear.append(blob)
		if blob.fixed:
			fixedsWeStartedNear.append(blob)
			startedNearFixed = true
		
	
	
	
	for buddy in buddies:
		buddy.move(direction)
	
	
	
	if startedNearAnything:
		
		var leftSomethingAlone = false
		var connectedBlobs = getAllBlobsConnectedToSelf()
		for blob in anythingWeStartedNear:
			if !connectedBlobs.has(blob):
				leftSomethingAlone = true
				break
		
		if leftSomethingAlone:
			for buddy in buddies:
				buddy.move(direction,true)
			return false
		
		
	
	for buddy in buddies:
		buddy.checkIfShouldDie()
	
	return true
	

func getAllBlobsConnectedToSelf():
	var allBlobs = parentConglomerate.blobs
	#blob, checked
	var connectedBlobs = {self:false}
	
	var noChange = false
	while not noChange:
		# we haven't done anything yet
		noChange = true
		
		#loop through all the blobs we touch
		for blob in connectedBlobs.keys():
			
			#if we haven't checked it already
			if !connectedBlobs[blob]:
				
				#mark it as checked
				connectedBlobs[blob] = true
				
				#get all it's neighbors
				for adjacent in blob.getAdjacentBlobs():
					
					#make sure we haven't seen them
					if !connectedBlobs.keys().has(adjacent):
						
						#add them to our list
						connectedBlobs[adjacent] = false
						noChange = false
				
		
		
		
	return connectedBlobs.keys()
	
	pass

#this function can't fix the blobs
func move(direction,backwards = false):
	
	var newDirection = -direction if backwards else direction
	
	if backwards:
		stepsThisMove -= 1
	else:
		stepsThisMove += 1
	
	position += newDirection * STEPSIZE
	
	pass

func changeAlliegience(newParentConglomerate : Node2D):
	#reparent(newParentConglomerate,true)
	parentConglomerate.blobs.erase(self)
	get_parent().remove_child(self)
	newParentConglomerate.add_child(self)
	
	newParentConglomerate.setBlobs()
	
	pass


func getAdjacentBlobs():
	
	var blobs = []
	
	for blob in parentConglomerate.blobs:
		
		if blob == self:
			continue
		
		if blob.position.distance_to(position) < STEPSIZE * 1.5:
			blobs.append(blob)
		
	
	return blobs
	pass

func getBlobInPosition(position):
	
	for blob in parentConglomerate.blobs:
		
		if blob == self:
			continue
		
		if blob.position.distance_to(position) < 1:
			return blob
		
	
	return null
	



func setColor(num):
	
	$AnimatedSprite2D.set_frame(num)
	
	pass

func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"position" : position, 
		"lastPos" : lastPos,
		"parentConglomerate" : parentConglomerate,
		"modulate" : modulate,
		"alive" : alive
	}
	return save_dict
