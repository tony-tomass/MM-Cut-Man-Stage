extends Node2D

@export var mute: bool = false

@onready var enemy_damage: AudioStreamPlayer = $EnemyDamage
@onready var enemy_shoot: AudioStreamPlayer = $EnemyShoot
@onready var enemy_dink: AudioStreamPlayer = $EnemyDink
@onready var stage_music: AudioStreamPlayer = $StageMusic
@onready var intro_music: AudioStreamPlayer = $IntroMusic
@onready var mega_man_shoot: AudioStreamPlayer = $MegaManShoot
@onready var mega_man_land: AudioStreamPlayer = $MegaManLand
@onready var mega_man_damage: AudioStreamPlayer = $MegaManDamage
@onready var mega_man_defeat: AudioStreamPlayer = $MegaManDefeat

func _ready() -> void:
	if !mute:
		play_intro_music()

func play_intro_music() -> void:
	if !mute:
		intro_music.play()

func play_stage_music() -> void:
	if !mute:
		stage_music.play()

func play_enemy_damage() -> void:
	if !mute:
		enemy_damage.play()
		
func play_enemy_shoot() -> void:
	if !mute:
		enemy_shoot.play()

func play_enemy_dink() -> void:
	if !mute:
		enemy_dink.play()

func play_mega_man_shoot() -> void:
	if !mute:
		mega_man_shoot.play()
		
func play_mega_man_land() -> void:
	if !mute:
		mega_man_land.play()
		
func play_mega_man_damage() -> void:
	if !mute:
		mega_man_damage.play()

func play_mega_man_defeat() -> void:
	if !mute:
		mega_man_defeat.play()

func _on_intro_music_finished() -> void:
	play_stage_music()
