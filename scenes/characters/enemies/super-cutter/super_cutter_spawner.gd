extends Node2D

@onready var fire_delay: Timer = $FireDelay

var preload_cutter = preload("res://scenes/characters/enemies/super-cutter/super_cutter.tscn")
var spawning: bool

func _ready() -> void:
	spawning = false

func _process(delta: float) -> void:
	if spawning and fire_delay.is_stopped():
		fire_delay.start(0.45)
		shoot()

func shoot() -> void:
	var cutter = preload_cutter.instantiate()
	cutter.position = position
	get_tree().current_scene.add_child(cutter)

func _on_area_2d_body_entered(body: Node2D) -> void:
	#print("entered zone")
	if body.is_in_group("Player"):
		spawning = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	#print("exited zone")
	if body.is_in_group("Player"):
		spawning = false
