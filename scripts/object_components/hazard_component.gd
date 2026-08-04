class_name HazardComponents
extends Node


@export var _knockback_force := 20.0
var _hazard: Area2D


func _ready() -> void:
	_hazard = $".."
	_hazard.body_entered.connect(_on_body_entered)


func _exit_tree() -> void:
	_hazard.body_entered.disconnect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	var health_component: HealthComponent = body.get_node("HealthComponent")
	
	if health_component:
		health_component.take_damage(1, _hazard.global_position, _knockback_force)
