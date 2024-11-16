extends Node2D

const RedPoint:PackedScene = preload("res://components/points/red_point.tscn");
const RedBlock:PackedScene = preload("res://components/blocks/red_block.tscn");
const BluePoint:PackedScene = preload("res://components/points/blue_point.tscn");
const BlueBlock:PackedScene = preload("res://components/blocks/blue_block.tscn");

@export var speed:int = 250;
@export var wait_timer_range:Vector2 = Vector2(1, 3);

var is_game_over:bool = false;
var score_count:int = 0;
var high_score:int = 100;

func _ready() -> void:
	spawn_for_blue()
	spawn_for_red()
	
	$CanvasLayer/GameOver.hide()


func spawn_for_red():
	if not is_game_over:
		spawn_point_or_block($SpawnMarkers/RedLaneSpawnMarker2D, $SpawnMarkers/RedLaneSpawnMarker2D2, 
			RedPoint, RedBlock)
		start_timer_with_random_wait_time($RedLaneTimer)


func spawn_for_blue():
	if not is_game_over:
		spawn_point_or_block($SpawnMarkers/BlueLaneSpawnMarker2D, $SpawnMarkers/BlueLaneSpawnMarker2D2, 
			BluePoint, BlueBlock)
		start_timer_with_random_wait_time($BlueLaneTimer)


func start_timer_with_random_wait_time(timer: Timer) -> void:
	timer.wait_time = randi_range(wait_timer_range.x, wait_timer_range.y)
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


func _on_red_lane_timer_timeout() -> void:
	spawn_for_red()


func _on_blue_lane_timer_timeout() -> void:
	spawn_for_blue()


# for both the cars
func _on_car_scored() -> void:
	update_score(score_count + 1)


# for both the cars
func _on_car_blocked() -> void:
	print("game over - block")
	game_over_handler()


# game over if missed a point
func _on_missed_point_area_2d_area_entered(area: Area2D) -> void:
	print("game over - miss")
	game_over_handler()


# queue_free the blocks that were successfully missed
func _on_block_queue_free_area_2d_area_entered(area: Area2D) -> void:
	area.queue_free()


func game_over_handler() -> void:
	if not is_game_over: 
		is_game_over = true
	else: return
	
	# pause everything
	$RedCar.is_paused = true
	$BlueCar.is_paused = true
	get_tree().get_nodes_in_group("points").map(func (x) -> void: x.is_paused = true)
	get_tree().get_nodes_in_group("blocks").map(func (x) -> void: x.is_paused = true)
	
	$CanvasLayer/GameOver.show()
	$CanvasLayer/GameOver.set_score_values(score_count, high_score)


func reset() -> void:
	if is_game_over: 
		is_game_over = false
	else: return
	
	update_score(0)
	
	# resume everything
	$RedCar.is_paused = false
	$BlueCar.is_paused = false
	get_tree().get_nodes_in_group("points").map(func (x) -> void: x.queue_free())
	get_tree().get_nodes_in_group("blocks").map(func (x) -> void: x.queue_free())
	
	# restart spawning
	spawn_for_blue()
	spawn_for_red()
	
	$CanvasLayer/GameOver.hide()


func _on_game_over_restarted() -> void:
	reset()


func update_score(new_score:int) -> void:
	score_count = new_score
	$CanvasLayer/ScoreLabel.text = str(score_count)
