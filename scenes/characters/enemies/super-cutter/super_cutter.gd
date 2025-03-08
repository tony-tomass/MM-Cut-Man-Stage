#https://www.youtube.com/watch?v=0hMTWWJHzC8
extends Area2D

@onready var target = get_tree().get_nodes_in_group("Player")[0]
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var p0: Vector2
var p1: Vector2
var p2: Vector2
var time: float = 0.0
var target_pos: Vector2
var damage: int = 4

func _ready() -> void:
	target_pos = target.position
	p0 = position
	p1 = Vector2(target_pos.x, p0.y-310)
	p2 = target_pos
	p2.y += 150
	
	animated_sprite_2d.flip_h = position.x < target_pos.x

func _physics_process(delta: float) -> void:
	position = quadratic_bezier(time)
	time += delta
	if time >= 1:
		queue_free()

func quadratic_bezier(t: float) -> Vector2:
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	var r = q0.lerp(q1, t)
	return r

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.damage_health(damage)
