extends State

@export var idle_state: State

var game_start: bool = false

func enter() -> void:
	# Make a better version of this
	parent.visible = false
	await(get_tree().create_timer(3).timeout)
	parent.visible = true
	super()
	parent.velocity.x = 0
	
func process_frame(delta: float) -> State:
	if game_start:
		return idle_state
	return null
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "teleport":
		game_start = true
