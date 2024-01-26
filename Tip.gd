@tool

extends Node2D

@export var text : String = "" 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	$Label.text = text
	
	if Engine.is_editor_hint():
		return
	
	
	var showTip = false
	for body in ($Area2D as Area2D).get_overlapping_bodies():
		
		if body.parentConglomerate.isPlayable:
			showTip = true
		
		pass
	
	$Label.visible = showTip
	
	pass
