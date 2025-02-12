extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var shoot_delay_timer: Timer = $ShootDelayTimer

const SPEED = 250.0
const JUMP_VELOCITY = -730.0

var on_ladder : bool = false
var climbing : bool = false
var attacking: bool = false


func _physics_process(delta: float) -> void:
	if (velocity.x > 0 || velocity.x < 0):
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")
	
	if (velocity.x > 0):
		animated_sprite_2d.flip_h = true
	if (velocity.x < 0):
		animated_sprite_2d.flip_h = false
	
	# Add the gravity.
	if not is_on_floor() and !climbing:
		animated_sprite_2d.play("jump")
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("shoot") and shoot_delay_timer.is_stopped():
		animated_sprite_2d.play("idle_shoot")
		shoot_delay_timer.start()
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		climbing = false

	
	var direction := Vector2.ZERO
	direction.x = Input.get_axis("left","right")
	direction.y = Input.get_axis("up","down")
	
	if (Input.is_action_just_pressed("up") || Input.is_action_just_pressed("down")) and on_ladder:
		climbing = true
	if !on_ladder:
		climbing = false
	
	if climbing:
		animated_sprite_2d.play("climb")
		velocity.x = 0
		if direction.y:
			velocity.y = (direction.y * SPEED) / 1.5
		else:
			velocity.y = 0
		
		if (is_on_floor() and (Input.is_action_just_pressed("left") || Input.is_action_just_pressed("right"))) || Input.is_action_just_pressed("jump"):
			climbing = false
	else:
		if direction.x:
			velocity.x = move_toward(velocity.x, direction.x * SPEED, 30)
		else:
			velocity.x = move_toward(velocity.x, 0, 30)

	print(velocity.x)
	move_and_slide()

func _on_ladder_body_entered(body: Node2D) -> void:
	if (body.name == "MegaMan"):
		on_ladder = true


func _on_ladder_body_exited(body: Node2D) -> void:
	if (body.name == "MegaMan"):
		on_ladder = false
