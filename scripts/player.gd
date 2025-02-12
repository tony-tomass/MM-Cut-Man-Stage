class_name Player
extends CharacterBody2D

@onready var anim_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var effect_player: AnimationPlayer = $EffectPlayer
@onready var state_machine: Node = $StateMachine

@onready var active_weapon: Marker2D = %Buster

@export var health: int = 28

var on_ladder: bool = false
var recent_ladder_pos_x: int = 0

var iframes_active = false
signal got_hurt()
signal change_health(amount : int)
signal defeated()

func _ready() -> void:
	state_machine.init(self)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	
func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func get_active_weapon():
	return active_weapon

func _on_ladder_body_entered(body: Node2D) -> void:
	on_ladder = true
	print(on_ladder)

func _on_ladder_body_exited(body: Node2D) -> void:
	on_ladder = false
	#print(on_ladder)
	
func _on_ladder_ladder_x_pos(x: int) -> void:
	recent_ladder_pos_x = x + 14

func get_ladder_x_pos():
	return recent_ladder_pos_x

func damage_health(amount: int) -> void:
	if !iframes_active:
		got_hurt.emit()
		health -= amount
		change_health.emit(health)
		
		if health <= 0:
			defeated.emit()
		else:
			print("iframes active")
			#health_bar.value = health
			effect_player.play("fx_hurt")
			iframes_active = true
	
func _on_invin_timer_timeout() -> void:
	iframes_active = false
	effect_player.stop()
	print("iframes inactive")
