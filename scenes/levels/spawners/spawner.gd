extends Node2D

var preload_enemies:= [
	preload("res://scenes/characters/enemies/bunby-heli/bunby_heli.tscn"),
	preload("res://scenes/characters/enemies/blaster-beak/blaster_beak.tscn"),
	preload("res://scenes/characters/enemies/flea/flea.tscn"),
	preload("res://scenes/characters/enemies/ad-suzy/adhering_suzy.tscn"),
	preload("res://scenes/characters/enemies/mambu/mambu.tscn"),
	preload("res://scenes/characters/enemies/big-eye/big_eye.tscn")
]

@onready var spawn_timer: Timer = $SpawnTimer

@export var spawn_timer_sec: float = 5.0
@export var starting_direction: int = -1
@export var chosen_enemy:= 0
@export var auto_spawning: bool = false

var spawned: bool = false
var enabled: bool = false

func _process(delta: float) -> void:
	if auto_spawning and enabled:
		if !spawned:
			spawn()

func spawn() -> void:
	var preload_enemy = preload_enemies[chosen_enemy]
	var enemy = preload_enemy.instantiate()
	enemy.position = position
	enemy.set_starting_direction(starting_direction)
	get_tree().current_scene.add_child.call_deferred(enemy)
	
	spawned = true
	spawn_timer.start(spawn_timer_sec)

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	#print("visible")
	enabled = true
	if !spawned:
		spawn()

func _on_spawn_timer_timeout() -> void:
	#print("spawner ready")
	spawned = false

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	enabled = false
