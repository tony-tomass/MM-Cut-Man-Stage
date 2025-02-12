extends Area2D
class_name Ladder

signal ladder_x_pos(x: int)

func _on_body_entered(body: Node2D) -> void:
	print(position.x)
	ladder_x_pos.emit(position.x)
