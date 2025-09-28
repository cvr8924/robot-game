extends CharacterBody2D


@export var movement_data : PlayerMovementData
@onready var old_body = load("res://old_body.tscn")
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var attack_timer: Timer = $AttackTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hitbox: Hitbox = $Hitbox


var startPos : Vector2

func _ready() -> void:
	startPos = position
	animation_player.play("RESET")

func die()-> void:
	var old_bod = old_body.instantiate()
	old_bod.global_position = position
	var world = get_tree().current_scene
	world.add_child(old_bod)
	position = startPos

 
func _physics_process(delta: float) -> void:
	apply_grav(delta)
	handle_jump()
	var input_axis := Input.get_axis("ui_left", "ui_right")
	apply_accel(input_axis,delta)
	apply_friction(input_axis,delta)
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collision_obj = collision.get_collider()
		if collision_obj != null:
			if collision_obj.is_in_group("Pushable") and abs(collision_obj.get_linear_velocity().x) < movement_data.Max_Push_Velocity:
				collision_obj.apply_central_impulse(collision.get_normal() * -movement_data.Push_Force)
				box_recursion_thing(collision_obj, (collision.get_normal() * -movement_data.Push_Force))
		
		
	
	
	var wasOnFloor = is_on_floor()
	move_and_slide()
	var just_left_ledge = wasOnFloor and not is_on_floor() and velocity.y >= 0
	
	if just_left_ledge:
		coyote_timer.start()
				
	update_animations(input_axis)
	
	debug_die()

func apply_grav(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta	
		
		
func handle_jump():
		# Handle jump. Works for space but not face button on controller. Interesting ~CR
	if is_on_floor() or coyote_timer.time_left > 0.0:
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = movement_data.Jump_Velocity
	if not is_on_floor():
		if Input.is_action_just_released("ui_up") and velocity.y < (movement_data.Jump_Velocity/2):
			velocity.y = movement_data.Jump_Velocity / 2 #allows Short Jump
			

func apply_accel(input_axis,delta):
	if input_axis!= 0 :
		velocity.x = move_toward(velocity.x,movement_data.speed*input_axis,movement_data.Acceleration*delta)
	
func apply_friction(input_axis,delta):
	if input_axis == 0:
		velocity.x = move_toward(velocity.x,0,movement_data.Friction)


func update_animations(input_axis):
	if not attack_timer.time_left >0.0:
		if input_axis != 0:
			animated_sprite_2d.flip_h = input_axis < 0 
			animated_sprite_2d.play("Run")
			
		else:
			animated_sprite_2d.play("Idle")
		if not is_on_floor():
			animated_sprite_2d.play("Jump")
		
	if Input.is_action_just_pressed("ui_accept"):
		attack_timer.start()
		animated_sprite_2d.play("Attack")
		if animated_sprite_2d.flip_h:
			animation_player.play("Hitbox Animator Left")
		else:
			animation_player.play("Hitbox Animator Right")
		
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		die() # Replace with function body.

func debug_die():
	if Input.is_action_just_pressed("Debug_Button"):
		die()

func box_recursion_thing(collision_obj, impulse):
	for item in collision_obj.get_colliding_bodies():
		if item is RigidBody2D and item.is_in_group("Pushable") and item.global_position.y <= collision_obj.global_position.y:
			item.apply_central_impulse(impulse)
			#box_recursion_thing()
			
			
	
	
