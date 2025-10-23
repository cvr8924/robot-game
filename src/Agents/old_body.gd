extends RigidBody2D


@onready var hurtbox: Hurtbox = $Hurtbox
var health = 7
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hurtbox.hurt.connect(func(other_hitbox: Hitbox):
		health -= 1
		if health <= 0:
			queue_free()
	)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
