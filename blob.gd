extends StaticBody2D

class_name blobClass

var fixed = false

const STEPSIZE = 32
const DEBUG = true
const DEBUGTIME = 0.05
var parentConglomerate

# Called when the node enters the scene tree for the first time.
func _ready():
	lastPos = position
	
	$Label.text = str(randi() % 1000)
	
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
	#
	#raycast = $blobcast as RayCast2D
	#raycast.global_position = global_position
	#raycast.target_position = direction * STEPSIZE 
	#raycast.force_raycast_update()
	#currentlyTouchingBlob = raycast.is_colliding()
	#
	#
	#blobInFront = raycast.get_collider()
	#
	#raycast.target_position *= -1
	#raycast.force_raycast_update()
	#blobBehind = raycast.get_collider()
	#
	#raycast.target_position *= -1
	#raycast.force_raycast_update()
	
	blobInFront = getBlobInPosition(position + direction * STEPSIZE)
	blobBehind = getBlobInPosition(position + direction * -STEPSIZE)
	

#this function can fix blobs.
func tryMoveMeAndMyBuddies(direction):
	
	if fixed:
		$Blob.scale = Vector2.ONE * 1.5
	else:
		$Blob.scale = Vector2.ONE
	
	#buddies includes yourself
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
	
	for buddy in buddies:
		buddy.scale = Vector2.ONE * 2
	scale = Vector2.ONE * 3
	pass
	for buddy in buddies:
		buddy.scale = Vector2.ONE * 1
	
	
	if cannotMove:
		return false
	
	var startedNearFixed = false
	var fixedsWeStartedNear = []
	
	for blob in getAllBlobsConnectedToSelf():
		if blob.fixed:
			fixedsWeStartedNear.append(blob)
			startedNearFixed = true
		
		
		#for neighbor in buddy.getAdjacentBlobs():
			#if neighbor.fixed:
				#startedNearFixed = true
				#fixedsWeStartedNear.append(neighbor)
				#break
	
	var numMoved = 0
	
	for buddy in buddies:
		print("moving ",str(numMoved))
		numMoved += 1
		buddy.move(direction)
	
	print("finished moving" )
	
	if startedNearFixed:
		
		var touchingFixed = false
		
		for blob in getAllBlobsConnectedToSelf():
			
			if blob.fixed:
				touchingFixed = true
				break
			
		
		if !touchingFixed:
			pass
			for buddy in buddies:
				buddy.move(-direction)
			return false
		
		#var touchingFixed = false
		#
		#for buddy in buddies:
			#
			#for neighbor in buddy.getAdjacentBlobs():
				#
				#if neighbor.fixed:
					#
					#touchingFixed = true
					#break
			#
			#if touchingFixed:
				#break;
			#
		#
		#if !touchingFixed:
			#pass
			#for buddy in buddies:
				#buddy.move(-direction)
			#return false
		#
		var leftFixedAlone = false
		
		for blob in fixedsWeStartedNear:
			if !blob.getAllBlobsConnectedToSelf().has(self):
				leftFixedAlone = true
		
		if leftFixedAlone:
			for buddy in buddies:
				buddy.move(-direction)
			return false
		
		
	
	print("finished getting away from fixed")
	
	return true
	
	pass

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
	
	lastPos = position
	lastDir = direction
	
	print(position)
	position += direction * STEPSIZE
	print(position)
	
	pass

func tryMove(direction):
	if DEBUG:
		await get_tree().create_timer(DEBUGTIME).timeout
	
	lastPos = position
	lastDir = direction
	
	updateCurrentlyOnWall(direction)
	
	if currentlyTouchingWall:
		return false
	
	position += direction * STEPSIZE
	
	updateCurrentlyOnWall(direction)
	
	return true

func stepBackIfOverlapping():
	if DEBUG:
		await get_tree().create_timer(DEBUGTIME).timeout
	for blob in parentConglomerate.blobs:
		
		if blob == self:
			continue
		
		if blob.position.is_equal_approx(position):
			position -= lastDir * STEPSIZE
			currentlyTouchingWall = false
			return true;
		
	return false

func goBack():
	position = lastPos

func stepBack():
	if DEBUG:
		await get_tree().create_timer(DEBUGTIME).timeout
	position -= lastDir * STEPSIZE

func checkIfPositionIsValid():
	
	for blob in parentConglomerate.blobs:
		
		if blob == self:
			continue
		
		if blob.position.is_equal_approx(position):
			return false;
		
		if blob.position.distance_to(position) < STEPSIZE * 1.5:
			return true
		
	
	return false

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
	
