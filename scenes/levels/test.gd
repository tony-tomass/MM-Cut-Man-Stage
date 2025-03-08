extends Node

@onready var health_bar: TextureProgressBar = $UI/MMHealthBar
@onready var ready_label: Label = $UI/Texts/ReadyLabel

func _ready() -> void:
	AudioManager._ready()
	# Make a better version of this
	health_bar.visible = false
	ready_label.visible = true
	await(get_tree().create_timer(3.05).timeout)
	health_bar.visible = true
	ready_label.visible = false
