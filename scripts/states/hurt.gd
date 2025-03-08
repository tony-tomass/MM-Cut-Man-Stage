extends State

@export var idle_state: State
@export var fall_state: State
@export var defeat_state: State

@onready var invin_timer: Timer = $"../../InvinTimer"
@onready var hurt_timer: Timer = $HurtTimer

var invin_time: float = 3.0
var hurt_time: float = 0.55
var hitstop_time: float = 1
var recovered: bool
var defeated: bool = false

var defeat_effect = preload("res://scenes/effects/mm-defeat/defeat_particles.tscn")
var hurt_steam_effect = preload("res://scenes/effects/mm-hurt/hurt_steam_particles.tscn")

func enter() -> void:
	super()
	parent.velocity.x = 0
	AudioManager.play_mega_man_damage()
	start_hurt_steam_effect()
	#if defeated:
		#play_defeat()
	#else:
		#recovered = false
		#hurt_timer.start(hurt_time)
		#invin_timer.start(invin_time)
	recovered = false
	hurt_timer.start(hurt_time)
	invin_timer.start(invin_time)

func process_physics(delta: float) -> State:
	parent.move_and_slide()
	if !parent.is_on_floor():
		parent.velocity.y += gravity * delta
	else:
		parent.velocity.y = -300 + (gravity * delta)
		if !parent.anim_sprite_2d.flip_h:
			parent.velocity.x = delta + 40
		else:
			parent.velocity.x = delta - 40
	return null

func process_frame(delta: float) -> State:
	if recovered and !defeated:
		return idle_state
	if defeated:
		play_defeat()
		return defeat_state
	return null
	
func play_defeat() -> void:
	AudioManager.stage_music.stop()
	Engine.time_scale = 0
	await(get_tree().create_timer(hitstop_time, true, false, true).timeout)
	Engine.time_scale = 1
	
	AudioManager.play_mega_man_defeat()
	var effect = defeat_effect.instantiate()
	effect.position = parent.position
	get_parent().add_child(effect)
	parent.visible = false
	
	await(get_tree().create_timer(5).timeout)
	get_tree().reload_current_scene()

func start_hurt_steam_effect() -> void:
	var effect = hurt_steam_effect.instantiate()
	effect.position.x = parent.position.x
	effect.position.y = parent.position.y - 70
	get_parent().add_child(effect)

func _on_hurt_timer_timeout() -> void:
	recovered = true

func _on_mega_man_defeated() -> void:
	defeated = true
