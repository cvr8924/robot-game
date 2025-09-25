## Note To Self: Make this a  Custom Node type in the future.
## Thats how we generic-ify this kind of structure godotily

extends RigidBody2D

@onready var hurtbox: Hurtbox = $Hurtbox
var health = 4
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	contact_monitor = true
	hurtbox.hurt.connect(func(other_hitbox: Hitbox):
		health -= 1
		if health <= 0:
			queue_free()
	)
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	
	#for body in get_colliding_bodies():
	#	#print("Hello World")
	#	if body is RigidBody2D:
	#		for i in get_colliding_bodies():
	#			if i is CharacterBody2D:
	#				body.linear_velocity.x = linear_velocity.x
	
	pass
	#move_and_collide()
	#contact_monitor = true
	
