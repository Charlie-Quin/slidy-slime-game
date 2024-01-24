extends Control

@export var nextScene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$LevelTitle.visible_characters += 1
	pass


func _on_play_pressed():
	get_tree().change_scene_to_packed(nextScene)
	pass # Replace with function body.

var textLines = ["Why would you want to do that?", "No, don't.", "Hit play instead.", "It's more fun, I swear.", "You see, quitting is like deciding to eat broccoli at an ice cream parlor—totally against the natural order of things.", "Let me tell you a tale, a tale of a sock-eating monster named Fred.", "Once upon a time, in the land of mismatched socks and untangled headphone wires, there lived a peculiar creature named Fred.", "Fred had an insatiable appetite for socks.", "Yes, socks.", "Not the delicious kind, mind you, but the stinky, worn-out ones that you'd find hidden at the bottom of your laundry basket.", "Now, Fred wasn't always a sock connoisseur.", "It all started when he stumbled upon a magical sock drawer that transported him to a parallel universe filled with talking washing machines and rebellious irons.", "In this bizarre realm, the currency was mismatched socks, and Fred quickly became the wealthiest sock-eating monster in the land.", "But one day, disaster struck.", "The sock market crashed, leaving Fred in a state of sock-induced despair.", "He roamed the land, searching for the elusive golden sock—the key to reversing the sockpocalypse.", "As he traversed through fields of untangled headphone wires and mountains of mismatched socks, Fred's desperation grew.", "And that, my friend, is the story of Fred, the sock-eating monster.", "So, if you ever feel like quitting, just remember Fred and his quest for the golden sock.", "Press play","and embark on a journey filled with whimsy and wonder.", "The button labeled 'Quit' might as well be a portal to the land of monotony, where sock-eating monsters roam freely, and mismatched socks are the currency of choice.", "Picture this: you press 'Quit,' and suddenly, you find yourself face-to-face with Fred, who looks at you with big, pleading eyes, sock lint dangling from his monstrous teeth.", "He gestures towards the 'Play' button with a sock-covered paw, urging you to reconsider.", "In a desperate, sock-laden plea, Fred explains that the real adventure lies in the unexpected, in the joy of discovering new realms filled with quirky characters and absurd challenges.", "You hesitate for a moment, torn between the ordinary act of quitting and the extraordinary journey that awaits.", "And just as you're about to make your decision, a mischievous sock gnome appears, juggling mismatched socks and whispering tales of legendary sock quests and sock-eating dragons.", "The temptation is too much to resist.", "You chuckle at the absurdity of it all and, with a twinkle in your eye, hit 'Play' once again.", "As the title screen cheers in delight, Fred does a joyous sock dance, and the sock gnome disappears in a puff of sock-shaped smoke.", "And so, the adventure continues, fueled by the spirit of whimsy and the resilience to resist the mundane 'Quit' button.", "Because in this game of life, the unexpected twists and turns are what make it truly worthwhile.", "Press play and savor the delightful chaos that awaits.","Yes, chat gpt wrote all that."]

var shrunk = false

func _on_quit_pressed():
	
	if textLines.size() > 0:
		$LevelTitle.text = textLines.pop_front()
		$LevelTitle.visible_characters = 0
		
		if !shrunk:
			$AnimationPlayer.play("shrink")
			shrunk = true
		
		
	else:
		get_tree().quit()
	
	pass # Replace with function body.
