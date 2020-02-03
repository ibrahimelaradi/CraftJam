extends Node



func _process(delta):
	if Input.is_action_just_pressed("ui_home"):
		get_tree().change_scene("res://src/worlds/testworld2.tscn")
	if Input.is_action_just_pressed("ui_end"):
		save_game()
	if Input.is_action_just_pressed("ui_page_up"):
		print("load")
		load_game()
	


	
func save_game():
	var save_game = File.new()
	save_game.open("res://save_files/testworld.res", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		var node_data = i.call("save");
		save_game.store_line(to_json(node_data))
	save_game.close()
	
	
	
# is path independent.
func load_game():
	var save_game = File.new()
	if not save_game.file_exists("res://save_files/testworld.res"):
		return # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save_game.open("res://save_files/testworld.res", File.READ)
	
	while not save_game.eof_reached():
		var current_line = parse_json(save_game.get_line())
		if current_line == null:
			continue
		else:
			var new_object = load(current_line["filename"]).instance()
			get_node(current_line["parent"]).add_child(new_object)
			new_object.position = Vector2(current_line["pos_x"], current_line["pos_y"])
			# Now we set the remaining variables.
			for i in current_line.keys():
				if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
					continue
				new_object.set(i, current_line[i])
	
		
	save_game.close()