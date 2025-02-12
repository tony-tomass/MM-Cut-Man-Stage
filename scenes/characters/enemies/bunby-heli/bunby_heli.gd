extends Area2D

@export var speed : float = 3
@export var direction: int = -1

@export var health: int = 3
@export var damage: int = 3

@onready var attack_timer: Timer = $AttackTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurt_sound: AudioStreamPlayer = $HurtSound
@onready var target = get_tree().root.get_child(0).get_node("MegaMan")

var player_pos
var spawn_pos

enum States {
	MOVE,
	ATTACK,
	RECOVER,
}
var current_state = States.MOVE

var on_cooldown = false

signal defeated()

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
	pass
	
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
	hurt_sound.play()
	health -= amount
	if health <= 0:
		defeated.emit()
		#await hurt_sound.finished
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
