extends CharacterBody2D

@onready var animation: AnimatedSprite2D = $PlayerAnimation

## create global State value
var state: StateDelegate

var speed: float = 400

var gravity_vector: Vector2 = ProjectSettings.get_setting("physics/2d/default_gravity_vector")

var gravity_magnitude: int = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	# assing new StateDelaget
	state = StateDelegate.new()
	# set debug to true or not lol
	state.debug = true
	# add idle_state with enter and exit functon
	state.add_state(_idle_state, "IDLE", _idle_enter_state, _idle_exit_state)
	# add walk_staet you can omit enter and exit functions if you don't need them
	state.add_state(_walk_state, "WALK")
	state.add_state(_attack_state, "ATTACK")
	state.add_state(_slash_state,"SLASH")
	state.add_state(_jump_start,"JUMP")
	# set deffault state to _idle_state
	state.set_default_state(_idle_state)

func _process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity_vector.y * gravity_magnitude * delta
	if Input.is_action_just_pressed("Attack"):
		# you can also set state using set_state function
		state.set_state(_attack_state)
	var direction := Input.get_axis("walk_left","walk_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	if velocity.x < 0:
		animation.flip_h = true
	else:
		animation.flip_h = false
	if Input.is_action_pressed("Slash"):	
		state.set_state(_slash_state)
	elif Input.is_action_just_pressed("Jump"):
		if is_on_floor():
			state.set_state(_jump_start)
			velocity.y = -500
	state.tick()
	move_and_slide()
func _idle_enter_state() -> void:
	# enter state will run first when chaning state so set aniation and other values in enter state
	animation.play("Idle")
	
func _idle_state() -> Variant:
	if !velocity.is_zero_approx():
		# if state becomes invalid you can return function of other state to change to it 
		return _walk_state
	# if state is valid just return null
	return null

func _idle_exit_state() -> void:
	# exit state will run when changing state use it to clean up values
	pass

func _walk_state() -> Variant:
	animation.play("Run")
	if velocity.is_zero_approx():
		return _idle_state
	return null

func _attack_state() -> Variant: 
	# play animation wait for it to finish and change state to idle
	animation.play("Kick")
	await animation.animation_finished
	return _idle_state
func _slash_state() -> Variant:
	animation.play("Air_Slashing")
	await animation.animation_finished
	return _idle_state
	
func _jump_enter():
	animation.play("Jump_Start")
	await animation.animation_finished
	animation.play("Jump_Loop")
	
func _jump_start():
	animation.play("Jump_Loop")
	if is_on_floor() and velocity.y == 0:
		return _idle_state

	
