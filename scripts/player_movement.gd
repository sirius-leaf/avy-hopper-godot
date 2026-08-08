class_name PlayerMovement
extends CharacterBody2D


@export_group("Movement")
@export var _speed := 500.0

@export_group("Jump")
@export var _jump_buffer_time := 0.15
@export var _coyote_time := 0.15
@export var _max_jump := 2
@export var _jump_velocity := -800.0
@export var _air_jump_force := -600.0

var _jump_buffer_counter := 0.0
var _coyote_time_counter := 0.0
var _jump_remaining: int
var _is_buffering_jump := false
var _is_grounded: bool
var _was_grounded: bool
var _is_ground_check_hit: bool
var _was_ground_check_hit: bool

@onready var _ground_check: RayCast2D = $GroundCheck
@onready var _player_sprite: Sprite2D = $PlayerSprite


func _enter_tree() -> void:
	_jump_remaining = _max_jump	


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	_was_grounded = _is_grounded
	_is_grounded = is_on_floor()
	
	if not _was_grounded and _is_grounded:
		_jump_remaining = _max_jump
	
	_was_ground_check_hit = _is_ground_check_hit
	_is_ground_check_hit = _ground_check.is_colliding()
	
	var is_leaving_ground := _was_ground_check_hit and not _is_ground_check_hit
	
	if is_on_floor() or is_leaving_ground:
		_coyote_time_counter = _coyote_time
	else:
		_coyote_time_counter -= delta
	
	if _jump_buffer_counter > 0.0:
		_jump_buffer_counter -= delta
	
	if Input.is_action_just_pressed("player_jump"):
		_jump_buffer_counter = _jump_buffer_time
		
		if _ground_check.is_colliding():
			_is_buffering_jump = true
	
	if _jump_buffer_counter > 0.0:
		if (_coyote_time_counter > 0.0 and _jump_remaining == _max_jump) or is_leaving_ground:
			velocity.y = _jump_velocity; print("normal jump")
			_is_buffering_jump = false
			_jump_buffer_counter = 0.0
			_coyote_time_counter = 0.0
			
			if not is_leaving_ground:
				_jump_remaining -= 1
			else:
				_jump_remaining = _max_jump
		elif _jump_remaining > 0 and not _is_buffering_jump:
			velocity.y = _air_jump_force; print("air jump")
			_is_buffering_jump = false
			_jump_buffer_counter = 0.0
			_coyote_time_counter = 0.0
			_jump_remaining -= 1
	
	var direction := Input.get_axis("player_left", "player_right")
	
	if direction:
		velocity.x = direction * _speed
		_player_sprite.flip_h = direction < 0.0
	else:
		velocity.x = move_toward(velocity.x, 0, _speed)

	move_and_slide()
