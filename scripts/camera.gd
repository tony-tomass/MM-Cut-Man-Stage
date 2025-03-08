extends Camera2D

@export var start_left: int = 0
@export var start_top: int = 0
@export var start_right: int = 0
@export var start_bottom: int = 0

#var dest_left: int = 0
#var dest_top: int = 0
#var dest_right: int = 0
#var dest_bottom: int = 0
#
#var room_entered: bool = false

func _ready() -> void:
	#room_entered = false
	limit_left = start_left
	limit_top = start_top
	limit_right = start_right
	limit_bottom = start_bottom
	
#func _process(delta: float) -> void:
	#if room_entered:
		#transition()

func _on_room_entered(left: int, top: int, right: int, bottom: int) -> void:
	limit_left = left
	limit_top = top
	limit_right = right
	limit_bottom = bottom
	
	#room_entered = true
	#dest_left = left
	#dest_top = top
	#dest_right = right
	#dest_bottom = bottom
	#transition()

#func transition() -> void:
	#limit_left = dest_left
	#limit_top = move_toward(start_top, dest_top, 2)
	#limit_right = dest_right
	#limit_bottom = move_toward(start_bottom, dest_bottom, 2)
