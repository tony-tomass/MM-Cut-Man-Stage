extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var target = get_tree().get_nodes_in_group("Player")[0]
@onready var jump_delay: Timer = $JumpDelay

var speed: float = 400.0
var jump_height: float = -800.0
var jump_distance: float = 200.0
var jump_delay_sec: float = 1.25
var damage: int = 2
var health: int = 1
var target_pos: Vector2
var defeat_effect = preload("res://scenes/effects/bomb-explode/bomb_explode_particles.tscn")

func _ready() -> void:
	handle_direction(jump_distance)

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		animation_player.play("jump")
		velocity += get_gravity() * delta
	else:
		animation_player.play("idle")
		velocity.x = 0
		if jump_delay.is_stopped():
			velocity = jump_modes()
			jump_delay.start(jump_delay_sec)
	
	move_and_slide()

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

func jump_modes() -> Vector2:
	var rng = RandomNumberGenerator.new()
	var mode_num = rng.randi_range(1, 3)
	var jump_mode: Vector2
	
	if mode_num == 1:
		jump_mode = Vector2(jump_distance*2, jump_height/1.25)
	elif mode_num == 2:
		jump_mode = Vector2(jump_distance/1.25, jump_height*1.25)
	else:
		jump_mode = Vector2(jump_distance, jump_height)
	
	jump_mode.x = handle_direction(jump_mode.x)
	#print(jump_mode)
	return jump_mode

func handle_direction(x: float) -> float:
	target_pos = target.position
	if position.x < target_pos.x:
		#print("<")
		return abs(x)
	else:
		#print(">")
		return x * -1

func set_starting_direction(_value: int) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.damage_health(damage)

func _on_area_2d_hurt(amount: int) -> void:
	damage_health(amount)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
