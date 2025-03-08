extends Area2D

@export var speed: float = 800
@export var direction: int = 1
@export var damage: int = 3

func _ready() -> void:
	AudioManager.play_mega_man_shoot()

func _physics_process(delta: float) -> void:
	position.x += direction * speed * delta

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemies"):
		area.damage_health(damage)
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
