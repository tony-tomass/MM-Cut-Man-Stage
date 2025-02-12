extends Marker2D

var preload_buster_shot = preload("res://scenes/weapons/mega_buster/mega_buster_bullet.tscn")

@onready var fire_delay_timer := $DelayTimer
@export var fire_delay: float = 0.1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_preload():
	return preload_buster_shot
