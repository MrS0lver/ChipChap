extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $Animation
@onready var health_commponent: HealthCommponent = $HealthCommponent
@onready var hit_box: Hitbox2D = $Hitbox2D
@onready var attack_timer: Timer = $AttackTimer
@onready var player_raycast_left: RayCast2D = $RayCast2DLeft
@onready var player_raycast_right: RayCast2D = $RayCast2DRight

var state: StateDelegate

var flip: bool = false

var _can_attack: bool = true

func _ready() -> void:
	state = StateDelegate.new()
	state.add_state(_idle_state, "IDLE", _idle_enter_state)
	state.add_state(_attack_state, "Attack", _attack_enter_state, _attack_exit_state)
	state.set_default_state(_idle_state)
	attack_timer.timeout.connect(func() -> void: _can_attack = true)
	health_commponent.hp_zero.connect(_despawn)
	


func _process(_delta: float) -> void:
	if state.is_state(_idle_state) and _can_attack:
		if player_raycast_left.is_colliding():
			flip = true
			state.set_state(_attack_state)
		elif player_raycast_right.is_colliding():
			flip = false
			state.set_state(_attack_state)
			
	state.tick()

func _idle_enter_state() -> void:
	animated_sprite_2d.play("Idle")
	pass

func _idle_state() -> Variant:
	return null

func _attack_enter_state() -> void: 
	_can_attack = false
	animated_sprite_2d.flip_h = flip
	if flip: 
		hit_box.scale.x = - 1
	else:
		hit_box.scale.x = 1

	hit_box.collision_shape.disabled = false

func _attack_state() -> Variant:
	animated_sprite_2d.play("Slashing")
	await animated_sprite_2d.animation_finished
	return _idle_state

func _attack_exit_state() -> void:
	hit_box.collision_shape.disabled = true
	attack_timer.start()

func _despawn():
	queue_free()
