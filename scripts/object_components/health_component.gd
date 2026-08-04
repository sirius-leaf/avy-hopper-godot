class_name HealthComponent
extends Node


signal health_changed(health: int)

@export var max_health := 10
@export var _sprite: Sprite2D
@export var _i_frame_time := 1.0
@export var _knockback_damping := 50.0
@export var _knockback_multiplier := Vector2(1.0, 0.5)

var health: int
var _character: Node2D
var _i_frame_counter := 0.0
var _velocity := Vector2.ZERO # vector.x = angle(deg), vector.y = magnitude


func _enter_tree() -> void:
	health = max_health


func _ready() -> void:
	_character = $".."


func _process(delta: float) -> void:
	if _i_frame_counter > 0.0:
		_i_frame_counter -= delta;
		_sprite.modulate = Color(1.0, 1.0, 1.0, 0.5)
	else:
		_sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)


func _physics_process(delta: float) -> void:
	var current_velocity = Vector2(cos(deg_to_rad(_velocity.x)) * _velocity.y * _knockback_multiplier.x, 
			min(0.0, sin(deg_to_rad(_velocity.x))) * _velocity.y * _knockback_multiplier.y)
	
	if _velocity.y > 0.0:
		_velocity.y = max(0.0, _velocity.y - delta * _knockback_damping)
	
	_character.global_position += current_velocity


func take_damage(damage: int, knockbackOrigin := Vector2.ZERO, knockbackForce := 0.0) -> void:
	if (_i_frame_counter <= 0.0):
		health -= damage; print(health)
		health_changed.emit(health)
		_i_frame_counter = _i_frame_time
		
		if knockbackOrigin:
			_velocity = Vector2(rad_to_deg(knockbackOrigin.angle_to_point(_character.global_position)),
					knockbackForce)
		
		if health <= 0:
			_character.queue_free()
