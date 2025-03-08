extends Area2D

@export var speed: float = 650.0
@export var direction: Vector2 = Vector2(0.0, 0.0)
@export var damage: int = 2

@onready var sound: AudioStreamPlayer = $Sound

func _ready() -> void:
	#sound.play()
	pass

func _physics_process(delta: float) -> void:
	position += direction.normalized() * speed * delta
	
func set_direction(x: float, y: float):
	direction = Vector2(x, y)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.damage_health(damage)
