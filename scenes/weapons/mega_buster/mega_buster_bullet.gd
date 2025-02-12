extends Area2D

@export var speed: float = 600
@export var direction: int = 1

@export var damage: int = 3

@onready var sound: AudioStreamPlayer = $Sound

func _ready() -> void:
	sound.play()

func _physics_process(delta: float) -> void:
	position.x += direction * speed * delta

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemies"):
		area.damage_health(3)
		queue_free()
