@tool

extends Node2D

@export_multiline var text : String = "" 

@export_range(0.09,10.01) var textScale : float = 1.0

@export_range(-1000.0,1000.0) var offsetX : float = 0
@export_range(-1000.0,1000.0) var offsetY : float = 0

@export var showWhenTouched = true
@export var showWhenPlayerIsDead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$Label.visible = false
	
	if Engine.is_editor_hint():
		$Label.visible = true
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	$Label.text = text
	$Label.scale = textScale * Vector2.ONE
	$Label.position = Vector2(offsetX - $Label.size.x/2.0,offsetY - $Label.size.y/2.0)
	
	if Engine.is_editor_hint():
		return
	
	
	var showTip = false
	
	if showWhenTouched and ($RayCast2D as RayCast2D).is_colliding():
		showTip = true
	
	
	if showWhenPlayerIsDead:
		var playerExists = false
		for blob in get_tree().get_nodes_in_group("blob"):
			if blob.isPlayer():
				playerExists = true
				break
		
		if !playerExists:
			showTip = true
		
	
	$Label.visible = showTip
	
	pass
