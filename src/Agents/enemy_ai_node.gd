extends Node2D

@onready var path_follow : PathFollow2D = $Path2D/PathFollow2D
@export var speed = 60

func _process(delta: float) -> void:
	path_follow.progress += speed*delta
