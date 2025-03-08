extends Area2D

@onready var anim_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var shield_timer: Timer = $ShieldTimer
@onready var shoot_timer: Timer = $ShootTimer
@onready var fire_delay: Timer = $FireDelay
@onready var shoot_sound: AudioStreamPlayer = $ShootSound

enum States {
	SHIELD,
	SHOOT,
}

var current_state = States.SHIELD

var shield_time_sec: float = 2
var shoot_time_sec: float = 2.5
var bullet_direction: float = -1.0
var fire_delay_sec: float = 0.5
var bullet_count: int = 4
var bullet_angles = [-0.95, -0.15, 0.15, 0.95]
var preload_bullet = preload("res://scenes/characters/enemies/blaster-beak/blaster_beak_bullet.tscn")
var defeat_effect = preload("res://scenes/effects/bomb-explode/bomb_explode_particles.tscn")
var health: int = 3
var damage: int = 1

func _ready() -> void:
	flip_sprite()
	handle_modes()
	
func handle_modes() -> void:
	if current_state == States.SHIELD:
		shield()
	if current_state == States.SHOOT:
		shoot()

func shield() -> void:
	#print("shield mode")
	if shield_timer.is_stopped():
		anim_player.queue("shield")
		shield_timer.start(shield_time_sec)

func shoot() -> void:
	#print("shoot mode")
	if shoot_timer.is_stopped():
		anim_player.queue("shoot")
		
		shoot_timer.start(shoot_time_sec)
		
		for n in bullet_count:
			fire_delay.start(fire_delay_sec)
			await(fire_delay.timeout)
			var bullet = preload_bullet.instantiate()
			bullet.set_direction(bullet_direction, bullet_angles[n])
			get_tree().current_scene.add_child(bullet)
			bullet.global_position = global_position
			shoot_sound.play()
		

func change() -> void:
	if current_state == States.SHIELD:
		anim_player.play("change")
		await(get_tree().create_timer(0.25).timeout)
		current_state = States.SHOOT
		
	elif current_state == States.SHOOT:
		anim_player.play_backwards("change")
		current_state = States.SHIELD
		
	handle_modes()

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

func set_starting_direction(value: int) -> void:
	bullet_direction = value

func flip_sprite() -> void:
	if bullet_direction > 0:
		scale.x *= -1

func _on_shield_timer_timeout() -> void:
	change()

func _on_shoot_timer_timeout() -> void:
	change()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.damage_health(damage)
