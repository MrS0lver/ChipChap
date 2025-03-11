extends CharacterBody2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

## Create global State value
var state: StateDelegate

var speed: float = 400
var jump_force: float = -400  # Upward force when jumping
var last_platform_velocity = Vector2.ZERO


var gravity_vector: Vector2 = ProjectSettings.get_setting("physics/2d/default_gravity_vector")
var gravity_magnitude: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var spawn_pos: Vector2  # Fixed spelling from 'spown_pos' to 'spawn_pos'

func _ready() -> void:
	# Assign new StateDelegate
	state = StateDelegate.new()
	spawn_pos = position
	state.debug = true
	
	# Add states
	state.add_state(_idle_state, "IDLE", _idle_enter_state, _idle_exit_state)
	state.add_state(_walk_state, "WALK")
	state.add_state(_attack_state, "ATTACK")
	state.add_state(_slash_state, "SLASH")
	state.add_state(_jump_start, "JUMP", _jump_enter)  # Ensure jump has an enter function
	state.add_state(_fall_state, "FALL", _fall_enter)  # Ensure fall state is added

	# Set default state
	state.set_default_state(_idle_state)
	BackGroundMusic.play()
	

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity += (get_gravity() * delta)
	 
	# Attack input
	if Input.is_action_just_pressed("Slide"):
		state.set_state(_attack_state)
		#$Shape.position = Vector2(0,22)
	
	# Movement
	var direction := Input.get_axis("walk_left", "walk_right")
	if direction:
		velocity.x = direction * speed
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, speed)
	

	# Flip animation based on direction
	if direction != 0:
		animation.flip_h = direction < 0  # True if moving left, False if moving right
	
	# Slash attack input
	if Input.is_action_pressed("Slash"):
		state.set_state(_slash_state)
	
	# Jump input
	if  Input.is_action_just_pressed("Jump") and is_on_floor():
		state.set_state(_jump_start)
		velocity.y = jump_force  # Apply jump force
		velocity.x = last_platform_velocity.x
	#if Input.is_action_just_pressed("Menu"):
		#menu.instantiate()
	if Input.is_action_just_pressed("Menu"):
		pass
	
	# Reset position if falling out of bounds
	if position.y >= 670:
		position = spawn_pos

	move_and_slide()
	# State machine tick
	state.tick()
	last_platform_velocity = get_platform_velocity()

# ------------------------
# Idle State
# ------------------------
func _idle_enter_state() -> void:
	animation.play("Idle")

func _idle_state() -> Variant:
	$Shape.rotation_degrees = 0 
	$Shape.position = Vector2(0,-48)
	if !velocity.is_zero_approx():
		return _walk_state
	return null

func _idle_exit_state() -> void:
	pass

# ------------------------
# Walk State
# ------------------------
func _walk_state() -> Variant:
	animation.play("Run")
	if velocity.is_zero_approx():
		return _idle_state
	return null

# ------------------------
# Attack State
# ------------------------
func _attack_state() -> Variant:
	
	animation.play("Slide")
	$Shape.rotation_degrees = -90
	if animation.flip_h == true:
		$Shape.position = Vector2(26,-26)
	else:
		$Shape.position = Vector2(-26,-26)
	await animation.animation_finished
	return _idle_state
	

# ------------------------
# Slash Attack State
# ------------------------
func _slash_state() -> Variant:
	if is_on_floor():
		if velocity.x != 0:
			animation.play("Run_Slashing")
		else:
			animation.play("Slash")
	else:
		animation.play("Air_Slashing")
	await animation.animation_finished
	
	return _idle_state

# ------------------------
# Jump State
# ------------------------
func _jump_enter():
	$Shape.rotation_degrees = 0 
	$Shape.position = Vector2(0,-48)
	animation.play("Jump_Start")
	await animation.animation_finished
	animation.play("Jump_Loop")

func _jump_start() -> Variant:
	if velocity.y > 0:  # Player is now falling
		return _fall_state  # Transition to fall state
	return null  # Stay in jump state

# ------------------------
# Falling State
# ------------------------
func _fall_enter():
	animation.play("Falling")

func _fall_state() -> Variant:
	if is_on_floor():  # Player landed
		return _idle_state  # Transition back to idle
	return null  # Stay in falling state
