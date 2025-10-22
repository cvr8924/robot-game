extends CharacterBody2D

@onready var hurtbox: Hurtbox = $Hurtbox
var health = 1


func _ready() -> void:
	hurtbox.hurt.connect(func(other_hitbox: Hitbox):
		health -= 1
		if health <= 0:
			queue_free()
	)
	pass # Replace with function body.
