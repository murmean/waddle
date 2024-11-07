extends CharacterBody2D

var gravity 
#Player Movement
@export var speed = 100.0
@export var walkSpeed = 50.0
@export var acceleration = 800.0
@export var friction = 1000.0
@export var jump_velocity = -300.0
@export var air_resistance = 200.0
@export var air_acceleration = 400.0
#Refrences
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var coyote_timer = $coyote_jump_timer
@onready var starting_position = global_position
@onready var jump_buffer = $jump_buffer
@onready var interact_ui = $interact_ui


#KinematicEquations
var max_jump_height = 2.25 * 32
var min_jump_height = 0.8 * 32
var jump_duration = 0.5
var max_jump_velocity
var min_jump_velocity 
var last_location

#platformVelocity
#var platVel = Vector2(0,0)

func _ready():
	calculate_gravity_and_jump_vel()
	Inventory.set_player_reference(self)
	


func _physics_process(delta):
	apply_gravity(delta)
	handle_jump()
	var input_axis = Input.get_axis("left", "right")
	handle_acceleration(input_axis, delta)
	handle_air_acceleration(input_axis, delta)
	apply_friction(input_axis, delta)
	apply_air_resistance(input_axis, delta)
	var was_on_floor = is_on_floor()
	#Tp la ultimul loc
	if is_on_floor():
		last_location = global_position
	move_and_slide()
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_ledge:
		coyote_timer.start()
	##TODO fix this shit
	#if is_on_floor() && !jump_buffer.is_stopped():
		#jump_buffer.stop()
		#handle_jump()
	#platVel = get_platform_velocity()
	#update_animations(input_axis)

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity  * delta
		
	


func handle_jump():
	if is_on_floor()==true or coyote_timer.time_left > 0.0:
		if Input.is_action_just_pressed("up") :
			velocity.y = max_jump_velocity
			#velocity.x += platVel.x 
	elif not is_on_floor():
		if Input.is_action_just_released("up") and velocity.y < min_jump_velocity :
			velocity.y = min_jump_velocity

func handle_acceleration(input_axis, delta):
	if not is_on_floor(): return
	
	if input_axis != 0 && !Input.is_action_pressed("walk"):
		velocity.x = move_toward(velocity.x, speed * input_axis, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 50 * input_axis, acceleration * delta)


	
func handle_air_acceleration(input_axis, delta):
	if is_on_floor(): return
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, speed * input_axis, air_acceleration * delta)

func apply_friction(input_axis, delta):
	if input_axis == 0 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, friction * delta)

func apply_air_resistance(input_axis, delta):
	if input_axis == 0 and not is_on_floor():
		velocity.x = move_toward(velocity.x, 0, air_resistance * delta)

func calculate_gravity_and_jump_vel():
	gravity = 2 * max_jump_height/ pow(jump_duration,2)
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height)
	min_jump_velocity = -sqrt(2 * gravity * min_jump_height)

#func update_animations(input_axis):
	#if input_axis != 0 :
		#animated_sprite_2d.flip_h = (input_axis < 0)
	#if input_axis !=0 && Input.is_action_pressed("walk"):
		#animated_sprite_2d.play("walk")
	#elif input_axis !=0 && !Input.is_action_pressed("walk"):
		#animated_sprite_2d.play("run")
	#else:
		#animated_sprite_2d.play("default")
	#
	#if not is_on_floor():
		#animated_sprite_2d.play("jump")
