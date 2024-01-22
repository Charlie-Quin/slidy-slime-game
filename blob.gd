extends StaticBody2D

class_name blobClass

var fixed = false

const STEPSIZE = 32
const DEBUG = false
const DEBUGTIME = 0.05
var parentConglomerate

# Called when the node enters the scene tree for the first time.
func _ready():
	lastPos = position
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

var lastPos = Vector2.ZERO
var lastDir = Vector2.ZERO
var currentlyTouchingWall = false
var currentlyTouchingBlob = false

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
	

#this function can fix blobs.
func tryMoveMeAndMyBuddies(direction):
	
	var buddies = [self]
	
	var currentBlob = self
	
	currentBlob.updateCurrentlyOnWall(direction)
	
	currentBlob.updateCurrentlyOnWall(direction)
	while currentBlob.blobInFront != null:
		buddies.append(currentBlob.blobInFront)
		currentBlob = currentBlob.blobInFront
		currentBlob.updateCurrentlyOnWall(direction)
	currentBlob = self
	while currentBlob.blobBehind != null:
		buddies.append(currentBlob.blobBehind)
		currentBlob = currentBlob.blobBehind
		currentBlob.updateCurrentlyOnWall(direction)
	
	print(buddies.size())
	
	
	
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
				buddy.move(-direction)
			return false
		
		
	
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
func move(direction):
	
	position += direction * STEPSIZE
	
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
	
