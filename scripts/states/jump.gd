extends State

@export var fall_state: State
@export var idle_state: State
@export var run_state: State
@export var climb_state: State
@export var hurt_state: State

@export var jump_force: float = -790.0

@onready var land_sound: AudioStreamPlayer = %LandSound
	
func enter() -> void:
	super()
	parent.velocity.y = jump_force

func process_input(event: InputEvent) -> State:
	shoot()
	parent.anim_player.queue("jump")
	
	if (Input.is_action_pressed("up") or Input.is_action_pressed("down")) and parent.on_ladder:
		parent.position.x = parent.get_ladder_x_pos()
		return climb_state
		
	return null

func process_frame(delta: float) -> State:
	if got_hurt:
		return hurt_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
		
	var direction = Input.get_axis("left","right") * move_speed
	if direction != 0:
		parent.anim_sprite_2d.flip_h = direction > 0
	parent.velocity.x = direction
	parent.move_and_slide()
	
	
	if parent.is_on_floor():
		land_sound.play()
		if direction != 0:
			return run_state
		return idle_state
	
	return null

func shoot():
	var buster = parent.get_active_weapon()
	var preload_buster_shot = buster.get_preload()
	
	if Input.is_action_pressed("shoot") and buster.fire_delay_timer.is_stopped():
		parent.anim_player.play("jump_shoot")
		var buster_shot = preload_buster_shot.instantiate()
		
		if !parent.anim_sprite_2d.flip_h:
			buster_shot.direction = -1
			buster.position.x = -15
		else: 
			buster_shot.direction = 1
			buster.position.x = 15
			
		get_tree().current_scene.add_child(buster_shot)
		buster_shot.global_position = buster.global_position
		buster.fire_delay_timer.start(buster.fire_delay)


func _on_mega_man_got_hurt() -> void:
	got_hurt = true
