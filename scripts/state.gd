class_name State
extends Node

@export var anim_name : String
@export var move_speed: float = 250.0

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var parent: Player

var got_hurt: bool

func enter() -> void:
	got_hurt = false
	print(name)
	parent.anim_player.play(anim_name)
	
func exit() -> void:
	pass

func process_physics(delta: float) -> State:
	return null

func process_frame(delta: float) -> State:
	return null

func process_input(event: InputEvent) -> State:
	return null
