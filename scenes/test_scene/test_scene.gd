extends Node2D

const RedPoint:PackedScene = preload("res://components/points/red_point.tscn")
const RedBlock:PackedScene = preload("res://components/blocks/red_block.tscn")
const BluePoint:PackedScene = preload("res://components/points/blue_point.tscn")
const BlueBlock:PackedScene = preload("res://components/blocks/blue_block.tscn")

@export var speed:int = 250
@export var wait_timer_range:Vector2 = Vector2(1, 3)

func _ready() -> void:
	spawn_for_blue()
	spawn_for_red()


func spawn_for_red():
	spawn_point_or_block($RedLaneSpawnMarker2D, $RedLaneSpawnMarker2D2, RedPoint, 
		RedBlock)
	start_timer_with_random_wait_time($RedLaneTimer)


func spawn_for_blue():
	spawn_point_or_block($BlueLaneSpawnMarker2D, $BlueLaneSpawnMarker2D2, BluePoint, 
		BlueBlock)
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
