extends Node2D

const STEPSIZE = 32
const DEBUG = false
const DEBUGTIME = 0.01
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

func tryMove(direction):
	if DEBUG:
		await get_tree().create_timer(DEBUGTIME).timeout
	lastPos = position
	lastDir = direction
	
	var raycast = $raycast as RayCast2D
	
	raycast.target_position = direction * STEPSIZE 
	
	raycast.force_raycast_update()
	
	if raycast.is_colliding():
		return false
	
	position += direction * STEPSIZE
	
	raycast.force_raycast_update()
	if raycast.is_colliding():
		currentlyTouchingWall = true
	
	
	
	#if !parentConglomerate.checkIfBlobStateIsValid():
	#	position -= direction * STEPSIZE
	#	return false
	
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

