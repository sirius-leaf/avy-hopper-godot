class_name PlayerMovement
extends CharacterBody2D


@export_group("Movement")
@export var _speed := 500.0

@export_group("Jump")
@export var _jumpBufferTime := 0.15
@export var _coyoteTime := 0.15
@export var _maxJump := 2
@export var _jumpVelocity := -800.0
@export var _airJumpForce := -600.0
var _jumpBufferCounter := 0.0
var _coyoteTimeCounter := 0.0
var _jumpRemaining: int
var _isBufferingJump := false
var _isGrounded: bool
var _wasGrounded: bool
var _isGroundCheckHit: bool
var _wasGroundCheckHit: bool

@onready var groundCheck: RayCast2D = $GroundCheck
@onready var playerSprite: Sprite2D = $PlayerSprite


func _enter_tree() -> void:
	_jumpRemaining = _maxJump	


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	_wasGrounded = _isGrounded
	_isGrounded = is_on_floor()
	
	if not _wasGrounded and _isGrounded:
		_jumpRemaining = _maxJump
	
	_wasGroundCheckHit = _isGroundCheckHit
	_isGroundCheckHit = groundCheck.is_colliding()
	
	var isLeavingGround := _wasGroundCheckHit and not _isGroundCheckHit
	
	if is_on_floor() or isLeavingGround:
		_coyoteTimeCounter = _coyoteTime
	else:
		_coyoteTimeCounter -= delta
	
	if _jumpBufferCounter > 0.0:
		_jumpBufferCounter -= delta
	
	if Input.is_action_just_pressed("player_jump"):
		_jumpBufferCounter = _jumpBufferTime
		
		if groundCheck.is_colliding():
			_isBufferingJump = true
	
	if _jumpBufferCounter > 0.0:
		if (_coyoteTimeCounter > 0.0 and _jumpRemaining == _maxJump) or isLeavingGround:
			velocity.y = _jumpVelocity; print("normal jump")
			_isBufferingJump = false
			_jumpBufferCounter = 0.0
			_coyoteTimeCounter = 0.0
			
			if not isLeavingGround:
				_jumpRemaining -= 1
			else:
				_jumpRemaining = _maxJump
		elif _jumpRemaining > 0 and not _isBufferingJump:
			velocity.y = _airJumpForce; print("air jump")
			_isBufferingJump = false
			_jumpBufferCounter = 0.0
			_coyoteTimeCounter = 0.0
			_jumpRemaining -= 1
	
	var direction := Input.get_axis("player_left", "player_right")
	
	if direction:
		velocity.x = direction * _speed
		playerSprite.flip_h = direction < 0.0
	else:
		velocity.x = move_toward(velocity.x, 0, _speed)

	move_and_slide()
