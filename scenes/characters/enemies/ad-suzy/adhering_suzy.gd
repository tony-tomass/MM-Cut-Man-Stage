extends CharacterBody2D

@onready var move_delay: Timer = $MoveDelay
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var direction: int = -1

enum States {
	REST,
	AWAKE
}

var defeat_effect = preload("res://scenes/effects/bomb-explode/bomb_explode_particles.tscn")
var current_state = States.AWAKE
var speed: float = 350.0
var health: int = 15
var damage: int = 4

func _physics_process(_delta: float) -> void:
	#if direction > 0: # Going left and right
		#velocity.x = speed
		#move_and_slide()
		#if velocity.x == 0 and current_state == States.AWAKE:
			#current_state = States.REST
			#move_delay.start(3)
			#await(move_delay.timeout)
			#speed *= -1
#
	#elif direction < 0: # Going up and down
		#velocity.y = speed
		#move_and_slide()
		#if velocity.y == 0 and current_state == States.AWAKE:
			#current_state = States.REST
			#move_delay.start(3)
			#await(move_delay.timeout)
			#speed *= -1

	if direction > 0: # Going left and right
		velocity.x = speed
	elif direction < 0: # Going up and down
		velocity.y = speed
	
	move_and_slide()
	
	if velocity == Vector2(0, 0) and current_state == States.AWAKE:
		current_state = States.REST
		move_delay.start(3)
		await(move_delay.timeout)
		speed *= -1
	
	handle_states()

func handle_states() -> void:
	if current_state == States.REST:
		animated_sprite_2d.play("rest")
	if current_state == States.AWAKE:
		animated_sprite_2d.play("awake")
	
func set_starting_direction(value: int) -> void:
	direction = value
	
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

func _on_move_delay_timeout() -> void:
	current_state = States.AWAKE

func _on_area_2d_hurt(amount: int) -> void:
	damage_health(amount)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.damage_health(damage)
