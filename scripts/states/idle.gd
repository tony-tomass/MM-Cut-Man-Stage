extends State

@export var fall_state: State
@export var jump_state: State
@export var run_state: State
@export var climb_state: State
@export var hurt_state: State

func enter() -> void:
	super()
	parent.velocity.x = 0
	
func process_input(event: InputEvent) -> State:
	shoot()
	parent.anim_player.queue("idle")

	if Input.is_action_just_pressed("jump") and parent.is_on_floor():
		return jump_state
	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		return run_state
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
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state
	
	return null

func shoot():
	var buster = parent.get_active_weapon()
	var preload_buster_shot = buster.get_preload()
	
	if Input.is_action_pressed("shoot") and buster.fire_delay_timer.is_stopped():
		parent.anim_player.play("idle_shoot")
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
