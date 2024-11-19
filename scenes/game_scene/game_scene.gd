extends Node2D

const PinkPoint:PackedScene = preload("res://components/entities/points/pink_point.tscn");
const PinkBlock:PackedScene = preload("res://components/entities/blocks/pink_block.tscn");
const PurplePoint:PackedScene = preload("res://components/entities/points/purple_point.tscn");
const PurpleBlock:PackedScene = preload("res://components/entities/blocks/purple_block.tscn");

@export var speed:int = 500;
@export var wait_time:float = 1;

var is_game_over:bool = false;
var score_count:int = 0;
var high_score:int = 100;

func _ready() -> void:
	$CanvasLayer/Tutorial.show()
	$CanvasLayer/GameOver.hide()


func _on_tutorial_start() -> void:
	print("started")
	$CanvasLayer/Tutorial.hide()
	spawn_for_purple()
	spawn_for_pink()


func spawn_for_pink():
	if not is_game_over:
		spawn_point_or_block($SpawnMarkers/PinkLaneSpawnMarker2D, $SpawnMarkers/PinkLaneSpawnMarker2D2, 
			PinkPoint, PinkBlock)
		start_timer_with_random_wait_time($PinkLaneTimer)


func spawn_for_purple():
	if not is_game_over:
		spawn_point_or_block($SpawnMarkers/PurpleLaneSpawnMarker2D, $SpawnMarkers/PurpleLaneSpawnMarker2D2, 
			PurplePoint, PurpleBlock)
		start_timer_with_random_wait_time($PurpleLaneTimer)


func start_timer_with_random_wait_time(timer: Timer) -> void:
	#timer.wait_time = randi_range(wait_timer_range.x, wait_timer_range.y)
	timer.wait_time = wait_time
	timer.start()


func spawn_point_or_block(marker1:Marker2D, marker2:Marker2D, point:PackedScene, 
	block:PackedScene) -> void:
	
	# picking point or block
	var point_or_block_instance;
	if (randi_range(0,1)): point_or_block_instance = point.instantiate()
	else: point_or_block_instance = block.instantiate()
	
	point_or_block_instance.speed = speed
	
	# picking position
	if (randi_range(0,1)): point_or_block_instance.position = marker1.position
	else: point_or_block_instance.position = marker2.position
	
	add_child(point_or_block_instance)


func _on_pink_lane_timer_timeout() -> void:
	spawn_for_pink()


func _on_purple_lane_timer_timeout() -> void:
	spawn_for_purple()


# for both the boats
func _on_boat_scored() -> void:
	update_score(score_count + 1)


# for both the boats
func _on_boat_blocked() -> void:
	print("game over - block")
	game_over_handler()


# game over if missed a point
func _on_missed_point_area_2d_area_entered(area: Area2D) -> void:
	print("game over - miss")
	game_over_handler()
	
	if area.has_method("play_pulse"):
		area.play_pulse()


# queue_free the blocks that were successfully missed
func _on_block_queue_free_area_2d_area_entered(area: Area2D) -> void:
	area.queue_free()


func game_over_handler() -> void:
	if not is_game_over: 
		is_game_over = true
	else: return
	
	# pause everything
	%PinkBoat.is_paused = true
	%PurpleBoat.is_paused = true
	get_tree().get_nodes_in_group("points").map(func (x) -> void: x.is_paused = true)
	get_tree().get_nodes_in_group("blocks").map(func (x) -> void: x.is_paused = true)
	
	ScoreManager.update_high_score(score_count)
	ScoreManager.save_scores()
	
	$CanvasLayer/GameOver.set_score_values(score_count, ScoreManager.high_scores[0])
	$CanvasLayer/GameOver.show()


func reset() -> void:
	if is_game_over: 
		is_game_over = false
	else: return
	
	update_score(0)
	
	# resume everything
	%PinkBoat.is_paused = false
	%PurpleBoat.is_paused = false
	get_tree().get_nodes_in_group("points").map(func (x) -> void: x.queue_free())
	get_tree().get_nodes_in_group("blocks").map(func (x) -> void: x.queue_free())
	
	# restart spawning
	spawn_for_purple()
	spawn_for_pink()
	
	$CanvasLayer/GameOver.hide()


func update_score(new_score:int) -> void:
	score_count = new_score
	$CanvasLayer/ScoreLabel.text = str(score_count)


func _on_game_over_restarted() -> void:
	reset()


func _on_game_over_moved_to_home() -> void:
	get_tree().change_scene_to_file("res://scenes/menu_scene/menu_scene.tscn")


func _on_game_over_moved_to_high_score() -> void:
	get_tree().change_scene_to_file("res://scenes/high_score_score/high_score_scene.tscn")
