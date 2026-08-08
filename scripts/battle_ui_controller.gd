class_name BattleUiController
extends CanvasLayer


@export var _player: CharacterBody2D

var _player_health: HealthComponent

@onready var _player_health_bar: ProgressBar = $Control/PlayerHealthBar


func _ready() -> void:
	_player_health = _player.get_node("HealthComponent")
	
	_player_health.health_changed.connect(_on_player_health_changed)
	
	_player_health_bar.max_value = _player_health.max_health
	_player_health_bar.value = _player_health.health


func _exit_tree() -> void:
	_player_health.health_changed.disconnect(_on_player_health_changed)


func _on_player_health_changed(health: int) -> void:
	_player_health_bar.value = health
