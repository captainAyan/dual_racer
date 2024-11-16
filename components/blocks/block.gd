class_name Block

extends Area2D

@export var direction:Vector2 = Vector2.DOWN;
@export var speed:int = 100;

@export var is_paused:bool = false;


func _process(delta: float) -> void:
	if not is_paused:
		self.position += direction.normalized() * speed * delta


func play_pulse() -> void:
	$AnimationPlayer.play("pulse")
