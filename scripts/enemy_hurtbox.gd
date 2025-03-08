extends Area2D

signal hurt(amount: int)

func damage_health(value: int) -> void:
	hurt.emit(value)
