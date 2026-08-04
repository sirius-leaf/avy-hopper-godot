class_name HealthComponent
extends Node


@export var _sprite: Sprite2D
@export var _maxHealth := 10
@export var _iFrameTime := 1.0
@export var _knockbackDamping := 50.0
@export var _knockbackmultiplier := Vector2(1.0, 0.5)

var health: int
var _character: Node2D
var _iFrameCounter := 0.0
var _velocity := Vector2.ZERO # vector.x = angle(deg), vector.y = magnitude


func _enter_tree() -> void:
	health = _maxHealth


func _ready() -> void:
	_character = $".."


func _process(delta: float) -> void:
	if _iFrameCounter > 0.0:
		_iFrameCounter -= delta;
		_sprite.modulate = Color(1.0, 1.0, 1.0, 0.5)
	else:
		_sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)


func _physics_process(delta: float) -> void:
	var currentVelocity = Vector2(cos(deg_to_rad(_velocity.x)) * _velocity.y * _knockbackmultiplier.x, 
			min(0.0, sin(deg_to_rad(_velocity.x))) * _velocity.y * _knockbackmultiplier.y)
	
	if _velocity.y > 0.0:
		_velocity.y = max(0.0, _velocity.y - delta * _knockbackDamping)
	
	_character.global_position += currentVelocity


func take_damage(damage: int, knockbackOrigin := Vector2.ZERO, knockbackForce := 0.0) -> void:
	if (_iFrameCounter <= 0.0):
		health -= damage; print(health)
		_iFrameCounter = _iFrameTime
		
		if knockbackOrigin:
			_velocity = Vector2(rad_to_deg(knockbackOrigin.angle_to_point(_character.global_position)),
					knockbackForce)
		
		if health <= 0:
			_character.queue_free()
