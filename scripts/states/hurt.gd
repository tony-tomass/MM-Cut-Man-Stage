extends State

@export var idle_state: State
@export var fall_state: State

@onready var invin_timer: Timer = $"../../InvinTimer"
@onready var hurt_timer: Timer = $HurtTimer

@onready var hurt_sound: AudioStreamPlayer = %HurtSound
@onready var defeat_sound: AudioStreamPlayer = $"../../DefeatSound"


var invin_time: float = 4.0
var hurt_time: float = 0.75
var hitstop_time: float = 1
var recovered: bool
var defeated: bool = false

var defeat_effect = preload("res://scenes/effects/mm-defeat/defeat_particles.tscn")

func enter() -> void:
	super()
	parent.velocity.x = 0
	hurt_sound.play()
	if defeated:
		play_defeat()
	else:
		recovered = false
		hurt_timer.start(hurt_time)
		invin_timer.start(invin_time)
		parent.velocity.y = 0

func process_physics(delta: float) -> State:
	parent.move_and_slide()
	if !defeated:
		if !parent.anim_sprite_2d.flip_h:
			parent.velocity.x = delta + 40
		else:
			parent.velocity.x = delta - 40
	return null

func process_frame(delta: float) -> State:
	if recovered and !defeated:
		if !parent.is_on_floor():
			return fall_state
		return idle_state
	return null
	
func play_defeat() -> void:
	Engine.time_scale = 0
	await(get_tree().create_timer(hitstop_time, true, false, true).timeout)
	Engine.time_scale = 1
	
	defeat_sound.play()
	var effect = defeat_effect.instantiate()
	effect.position = parent.position
	get_parent().add_child(effect)
	parent.visible = false

func _on_hurt_timer_timeout() -> void:
	recovered = true

func _on_mega_man_defeated() -> void:
	defeated = true
