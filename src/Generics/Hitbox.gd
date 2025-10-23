class_name Hitbox extends Area2D

@export var dmg = 1.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area_2d: Area2D) -> void:
	if area_2d is Hurtbox:
		assert(area_2d is Hurtbox, "Invalid Hitbox Detection: This is not a Hurt Box :(")
		var hurtbox = area_2d as Hurtbox
		if hurtbox.is_invulnerable:
			return
		hurtbox.hurt.emit(self)
