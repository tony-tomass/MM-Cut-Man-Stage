extends State

@export var fall_state: State
@export var idle_state: State
@export var hurt_state: State

var shooting : bool = false

func enter() -> void:
	parent.velocity.x = 0
	super()
	
func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("jump"):
		return fall_state
	
	if Input.is_action_just_pressed("shoot"):
		shooting = true
		shoot()
	else:
		parent.anim_player.play("climb")
		shooting = false

	return null
	
func process_frame(delta: float) -> State:
	if got_hurt:
		return hurt_state
	return null

func process_physics(delta: float) -> State:
	
	if parent.velocity.y == 0:
		parent.anim_player.stop()
	
	if shooting == true:
		parent.velocity.y = 0
	else:
		var direction = Input.get_axis("up","down") * (move_speed/2)
	
		parent.velocity.y = move_toward(parent.velocity.y, direction, 110)
	
		parent.move_and_slide()
			
		if Input.is_action_just_pressed("left"):
			parent.anim_sprite_2d.flip_h = false
		if Input.is_action_just_pressed("right"):
			parent.anim_sprite_2d.flip_h = true
		
		if parent.is_on_floor() or (parent.on_ladder == false):
			return idle_state
	
	return null

func shoot():
	shooting = true
	parent.velocity.y = 0
	var buster = parent.get_active_weapon()
	var preload_buster_shot = buster.get_preload()
	
	parent.anim_player.play("climb_shoot")
	
	if buster.fire_delay_timer.is_stopped():
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
