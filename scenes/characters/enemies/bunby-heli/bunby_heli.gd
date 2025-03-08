extends Area2D

@onready var attack_timer: Timer = $AttackTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var target = get_tree().get_nodes_in_group("Player")[0]

var player_pos
var spawn_pos

var defeat_effect = preload("res://scenes/effects/bomb-explode/bomb_explode_particles.tscn")
var speed : float = 3
var direction: int = -1
var health: int = 3
var damage: int = 3

enum States {
	MOVE,
	ATTACK,
	RECOVER,
}
var current_state = States.MOVE

var on_cooldown = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	handle_direction()
	#print(target)
	spawn_pos = global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	animated_sprite_2d.flip_h = position.x < target.position.x
	handle_movement(delta)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.damage_health(damage)

func _on_area_2d_body_entered(body: Node2D) -> void:
	player_pos = body.position
	current_state = States.ATTACK
	
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.damage_health(damage)
	handle_direction()
	
func attack(delta: float) -> void:
	var original_pos = position
	var destination = player_pos
	var attack_speed = 14
	
	move(delta, speed)
	position.y = move_toward(original_pos.y, destination.y, delta + attack_speed)
	if position.y == destination.y:
		current_state = States.RECOVER
	
	#position = position.move_toward(destination, delta + attack_speed)
	#if position == destination:
		#current_state = States.RECOVER

func recover(delta: float) -> void:
	var current_pos = position
	var attack_speed = 6
	
	move(delta, speed)
	position.y = move_toward(current_pos.y,spawn_pos.y, delta + attack_speed)
	if position.y == spawn_pos.y:
		handle_direction()
		current_state = States.MOVE

func move(delta: float, move_speed: float) -> void:
	position.x += delta + move_speed * direction
	
func handle_direction() -> void:
	animated_sprite_2d.flip_h = position.x < target.position.x
	
	if position.x > target.position.x:
		direction = -1
	if position.x < target.position.x:
		direction = 1
	
func handle_movement(delta: float) -> void:
	if current_state == States.ATTACK:
		attack(delta)
	if current_state == States.RECOVER:
		recover(delta)
	else:
		move(delta, speed)
		
func damage_health(amount: int) -> void:
	AudioManager.play_enemy_damage()
	health -= amount
	if health <= 0:
		start_defeat_effect()
		queue_free()

func set_starting_direction(value: int) -> void:
	direction = value
	
func start_defeat_effect() -> void:
	var effect = defeat_effect.instantiate()
	effect.position = position
	get_parent().add_child(effect)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
