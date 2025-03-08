extends Area2D

@export var limit_left: int = 0
@export var limit_top: int = 0
@export var limit_right: int = 0
@export var limit_bottom: int = 0

signal room_entered(left: int, top: int, right: int, bottom: int)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		#print("entered")
		room_entered.emit(limit_left, limit_top, limit_right, limit_bottom)
