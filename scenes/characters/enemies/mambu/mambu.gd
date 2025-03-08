extends CharacterBody2D

@onready var shield_timer: Timer = $ShieldTimer
@onready var shoot_timer: Timer = $ShootTimer
@onready var fire_delay: Timer = $FireDelay
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var shoot_sound: AudioStreamPlayer = $ShootSound
@onready var shield_sound: AudioStreamPlayer = $ShieldSound

enum States {
	SHIELD,
	SHOOT
}

var current_state = States.SHIELD

var shield_time_sec: float = 1
var shoot_time_sec: float = 1
var fire_delay_sec: float = 0.25
var bullet_vectors = [ # Find an easier way to do this
	Vector2(0, -1),
	Vector2(-1, -1),
	Vector2(-1, 0),
	Vector2(-1, 1),
	Vector2(0, 1),
	Vector2(1, 1),
	Vector2(1, 0),
	Vector2(1, -1),
]
var bullet_count: int
var preload_bullet = preload("res://scenes/characters/enemies/blaster-beak/blaster_beak_bullet.tscn")
var defeat_effect = preload("res://scenes/effects/bomb-explode/bomb_explode_particles.tscn")
var health: int = 3
var damage: int = 1
var speed: float
const SPEED_VALUE: float = -200.0

func _ready() -> void:
	bullet_count = bullet_vectors.size()
	handle_modes()

func _physics_process(_delta: float) -> void:
	velocity.x = speed
	move_and_slide()

func shield() -> void:
	if shield_timer.is_stopped():
		speed = SPEED_VALUE
		animated_sprite_2d.play("shield")
		shield_timer.start(shield_time_sec)
		
func shoot() -> void:
	if shoot_timer.is_stopped():
		speed = 0.0
		animated_sprite_2d.play("shoot")
		shoot_timer.start(shoot_time_sec)
		fire_delay.start(fire_delay_sec)
		await(fire_delay.timeout)
		
		shoot_sound.play()

		for n in bullet_count:
			var bullet = preload_bullet.instantiate()
			bullet.set_direction(bullet_vectors[n].x, bullet_vectors[n].y)
			get_tree().current_scene.add_child(bullet)
			bullet.global_position = global_position

func change() -> void:
	if current_state == States.SHIELD:
		current_state = States.SHOOT
	elif current_state == States.SHOOT:
		current_state = States.SHIELD
	handle_modes()
	
func handle_modes() -> void:
	if current_state == States.SHIELD:
		shield()
	if current_state == States.SHOOT:
		shoot()

func damage_health(amount: int) -> void:
	if current_state == States.SHIELD:
		AudioManager.play_enemy_dink()
	else:
		AudioManager.play_enemy_damage()
		health -= amount
		if health <= 0:
			start_defeat_effect()
			queue_free()

func start_defeat_effect() -> void:
	var effect = defeat_effect.instantiate()
	effect.position = position
	get_parent().add_child(effect)

func set_starting_direction(_value: int) -> void:
	pass

func _on_shield_timer_timeout() -> void:
	change()

func _on_shoot_timer_timeout() -> void:
	change()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_area_2d_hurt(amount: int) -> void:
	damage_health(amount)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.damage_health(damage)
