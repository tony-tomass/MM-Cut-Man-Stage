extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var land_sound: AudioStreamPlayer = $LandSound
@onready var jump_delay: Timer = $JumpDelay
@onready var target = get_tree().get_nodes_in_group("Player")[0]

var jump_height: float = -600.0
var jump_distance: float = 150.0
var jump_delay_sec: float = 1
var direction: float = -1
var damage: int = 10
var health: int = 60
var target_pos: Vector2
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var defeat_effect = preload("res://scenes/effects/bomb-explode/bomb_explode_particles.tscn")

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		animation_player.play("jump")
		velocity.y += gravity * delta
		velocity.x = jump_distance * direction
	else:
		animation_player.play("idle")
		velocity.x = 0
		if jump_delay.is_stopped():
			velocity.y = jump_modes()
			jump_delay.start(jump_delay_sec)
	
	move_and_slide()

func handle_direction() -> void:
	target_pos = target.position
	if position.x < target_pos.x:
		direction = 1
	if position.x > target_pos.x:
		direction = -1
	animated_sprite_2d.flip_h = direction > 0

func set_starting_direction(value: int) -> void:
	direction = value

func jump_modes() -> float:
	var rng = RandomNumberGenerator.new()
	var mode_num = rng.randi_range(1, 3)
	var jump_mode: float
	
	handle_direction()
	
	if mode_num == 1:
		jump_mode = jump_height
	else:
		jump_mode = jump_height * 1.25
	
	return jump_mode

func damage_health(amount: int) -> void:
	AudioManager.play_enemy_damage()
	health -= amount
	if health <= 0:
		start_defeat_effect()
		queue_free()

func start_defeat_effect() -> void:
	var effect = defeat_effect.instantiate()
	effect.position = position
	get_parent().add_child(effect)

func _on_area_2d_hurt(amount: int) -> void:
	damage_health(amount)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.damage_health(damage)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
