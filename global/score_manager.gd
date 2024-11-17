extends Node

var high_scores:Array = [0,0,0]

var file_name = "user://game_data.save"

func _ready():
	print("loaded score")
	load_scores()

func update_high_score(current_score: int):
	high_scores = _add_new_score(current_score, high_scores)

# Function to add a new score to the high scores array
func _add_new_score(new_score: int, high_scores: Array):
	var updated_scores = high_scores  # Create a copy of the original array
	
	# Insert the new score into the array while maintaining descending order
	var inserted = false
	for i in range(updated_scores.size()):
		if new_score > updated_scores[i]:
			updated_scores.insert(i, new_score)
			inserted = true
			break
	
	# If the new score is not inserted yet, add it to the end of the array
	if not inserted:
		updated_scores.append(new_score)
	
	# Keep only the top 5 highest scores and discard the rest
	updated_scores = updated_scores.slice(0, 5)
	
	return updated_scores


func save_scores():
	var game_data = FileAccess.open(file_name, FileAccess.WRITE)
	var json_string:String = JSON.stringify(high_scores)
	game_data.store_line(json_string)

func load_scores():
	if not FileAccess.file_exists(file_name):
		print("Data file not found")
		var game_data = FileAccess.open(file_name, FileAccess.WRITE)
		var json_string:String = JSON.stringify(high_scores)
		game_data.store_line(json_string)
		return
	
	var game_data = FileAccess.open(file_name, FileAccess.READ)
	
	while game_data.get_position() < game_data.get_length():
		var json_string = game_data.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		high_scores = json.get_data()
