extends Node

var past = []
var ignoreInput = false


func _process(delta):
	
	if !ignoreInput and Input.is_action_just_pressed("rewind"):
		load_game()
		Globals.allTweensCurrently.clear()
		pass
	
	if !ignoreInput and Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	
	
	
	pass

# Note: This can be called from anywhere inside the tree. This function is
# path independent.
# Go through everything in the persist category and ask them to return a
# dict of relevant variables.
func save_game():
	var instance = []
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")
		
		instance.append(node_data)
		
	
	past.append(instance)
	

func discardLastSave():
	if past.size() == 0:
		return
	
	past.pop_back()
	
	

# Note: This can be called from anywhere inside the tree. This function
# is path independent.
func load_game():
	
	if past.size() == 0:
		return
	
	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()
	
	for node_data in past.pop_back():
		var new_object = load(node_data["filename"]).instantiate()
		
		get_node(node_data["parent"]).add_child(new_object)
		
		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "filename" or i == "parent":
				continue
			new_object.set(i, node_data[i])
	
	for node in get_tree().get_nodes_in_group("Persist_Update"):
		node.persistUpdate()
	
