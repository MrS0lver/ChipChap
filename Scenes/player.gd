#extends CharacterBody2D
#
#@onready var animation: AnimatedSprite2D = $PlayerAnimation
#
### create global State value
#var state: StateDelegate
#
#var speed: float = 400
#
#var gravity_vector: Vector2 = ProjectSettings.get_setting("physics/2d/default_gravity_vector")
#
#var gravity_magnitude: int = ProjectSettings.get_setting("physics/2d/default_gravity")
#
#var spown_pos : Vector2
#func _ready() -> void:
	## assing new StateDelaget
	#state = StateDelegate.new()
	## set debug to true or not lol
	#spown_pos = Vector2(450,20)
	#state.debug = true
	## add idle_state with enter and exit functon
	#state.add_state(_idle_state, "IDLE", _idle_enter_state, _idle_exit_state)
	## add walk_staet you can omit enter and exit functions if you don't need them
	#state.add_state(_walk_state, "WALK")
	#state.add_state(_attack_state, "ATTACK")
	#state.add_state(_slash_state,"SLASH")
	#state.add_state(_jump_start,"JUMP")
	#state.add_state(_fall_enter,"FALL")
	## set deffault state to _idle_state
	#state.set_default_state(_idle_state)
#
#func _process(delta: float) -> void:
	#if not is_on_floor():
		#velocity.y += gravity_vector.y * gravity_magnitude * delta
	#if Input.is_action_just_pressed("Attack"):
		## you can also set state using set_state function
		#state.set_state(_attack_state)
	#var direction := Input.get_axis("walk_left","walk_right")
	#if direction:
		#velocity.x = direction * speed
	#else:
		#velocity.x = move_toward(velocity.x, 0, speed)
	##if velocity.x < 0:
		##animation.flip_h = true
	##else:
		##animation.flip_h = false
	#
	#if direction != 0:  # Only flip when actually moving
		#animation.flip_h = direction < 0  # True if moving left, False if moving right
	#
	#if Input.is_action_pressed("Slash"):	
		#state.set_state(_slash_state)
	#elif Input.is_action_just_pressed("Jump"):
		#if is_on_floor():
			#state.set_state(_jump_start)
			#velocity.y = -400
	#if position.y >= 640:
		#position = spown_pos
	#state.tick()
	#move_and_slide()
#func _idle_enter_state() -> void:
	## enter state will run first when chaning state so set aniation and other values in enter state
	#animation.play("Idle")
	#
#func _idle_state() -> Variant:
	#if !velocity.is_zero_approx():
		## if state becomes invalid you can return function of other state to change to it 
		#return _walk_state
	## if state is valid just return null
	#return null
#
#func _idle_exit_state() -> void:
	## exit state will run when changing state use it to clean up values
	#pass
#
#func _walk_state() -> Variant:
	#animation.play("Run")
	#if velocity.is_zero_approx():
		#return _idle_state
	#return null
#
#func _attack_state() -> Variant: 
	## play animation wait for it to finish and change state to idle
	#animation.play("Kick")
	#await animation.animation_finished
	#return _idle_state
#func _slash_state() -> Variant:
	#animation.play("Air_Slashing")
	#await animation.animation_finished
	#return _idle_state
	#
#func _jump_enter():
	#animation.play("Jump_Start")
	#await animation.animation_finished
	#animation.play("Jump_Loop")
		#
	##await animation.animation_finished
	##animation.play("Falling")
	#
#func _jump_start():
	#animation.play("Jump_Loop")
	#if is_on_floor() and velocity.y == 0:
		#return _idle_state
		#
#func _fall_enter():
	#animation.play("Falling")
#
#func _fall_state() -> Variant:
	#if is_on_floor():
		#return _idle_state
	#return null
		#
	#













































extends CharacterBody2D

@onready var animation: AnimatedSprite2D = $PlayerAnimation

## Create global State value
var state: StateDelegate

var speed: float = 400
var jump_force: float = -400  # Upward force when jumping

var gravity_vector: Vector2 = ProjectSettings.get_setting("physics/2d/default_gravity_vector")
var gravity_magnitude: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var spawn_pos: Vector2  # Fixed spelling from 'spown_pos' to 'spawn_pos'

func _ready() -> void:
	# Assign new StateDelegate
	state = StateDelegate.new()
	spawn_pos = Vector2(450, 20)
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

func _process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity_vector.y * gravity_magnitude * delta
	
	# Attack input
	if Input.is_action_just_pressed("Attack"):
		state.set_state(_attack_state)
	
	# Movement
	var direction := Input.get_axis("walk_left", "walk_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	# Flip animation based on direction
	if direction != 0:
		animation.flip_h = direction < 0  # True if moving left, False if moving right
	
	# Slash attack input
	if Input.is_action_pressed("Slash"):
		state.set_state(_slash_state)
	
	# Jump input
	elif Input.is_action_just_pressed("Jump") and is_on_floor():
		state.set_state(_jump_start)
		velocity.y = jump_force  # Apply jump force

	# Reset position if falling out of bounds
	if position.y >= 640:
		position = spawn_pos

	# State machine tick
	state.tick()
	move_and_slide()
	print(velocity.x)

# ------------------------
# Idle State
# ------------------------
func _idle_enter_state() -> void:
	animation.play("Idle")

func _idle_state() -> Variant:
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
	await animation.animation_finished
	return _idle_state

# ------------------------
# Slash Attack State
# ------------------------
func _slash_state() -> Variant:
	if is_on_floor():
		if velocity.x != 0:
			animation.play("Run_Slashing")
			print("RUNING")
		else:
			animation.play("Slash")
			print("NORMAL SLASH")
	else:
		animation.play("Air_Slashing")
		print("AIR SLASHING")
	await animation.animation_finished
	
	return _idle_state

# ------------------------
# Jump State
# ------------------------
func _jump_enter():
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
