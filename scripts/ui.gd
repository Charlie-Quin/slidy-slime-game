@tool

extends Node2D

@export var levelTitle = "Level"
@export var levelSubText = "sub text"
@export_range(0.1,2.0) var zoom = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = true
	$title/LevelTitle.text = levelTitle
	$title/subTitle.text = levelSubText
	
	if Engine.is_editor_hint():
		return
	
	$AnimationPlayer.play("levelStart")
	$AnimationPlayer.advance(0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	visible = true
	$title/LevelTitle.text = levelTitle
	$title/subTitle.text = levelSubText
	
	$Camera2D.zoom = Vector2.ONE * zoom
	$Camera2D.position.x = (1920.0/2.0) / zoom
	$Camera2D.position.y = (1080.0/2.0) / zoom
	
	$title.scale = Vector2.ONE * (1.0/zoom)
	$frame.scale = Vector2.ONE * (1.0/zoom)
	
	pass
