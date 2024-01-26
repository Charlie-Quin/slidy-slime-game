@tool

extends Node2D

@export_multiline var text : String = "" 

@export var showWhenTouched = true
@export var showWhenPlayerIsDead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	$Label.text = text
	
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
