extends Node2D

var preload_enemies:= [
	preload("res://scenes/characters/enemies/bunby-heli/bunby-heli.tscn")
]

@onready var spawn_timer: Timer = $SpawnTimer
@export var spawn_timer_sec: float = 5.0

@export var chosen_enemy:= 0

var spawned : bool = false

func spawn() -> void:
	var preload_enemy = preload_enemies[chosen_enemy]
	var enemy = preload_enemy.instantiate()
	enemy.position = position
	get_tree().current_scene.add_child.call_deferred(enemy)
	
	spawned = true
	spawn_timer.start(spawn_timer_sec)

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	#print("visible")
	if !spawned:
		spawn()

func _on_spawn_timer_timeout() -> void:
	#print("spawner ready")
	spawned = false
