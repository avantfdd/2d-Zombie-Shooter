extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

signal player_hurt
const SPEED = 100.0
var direction = 1
@export var health: int = 100
var original_modulate: Color

func _ready() -> void:
	original_modulate = animated_sprite_2d.modulate
func _process(delta: float) -> void:
	position.x += direction * SPEED * delta
	


func _on_timer_timeout() -> void:
	direction *= -1
	animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and body.alive:
		emit_signal("player_hurt", body)
func take_damage(amount: int) -> void:
	health -= amount

	animated_sprite_2d.modulate = Color.RED

	if health <= 0:
		queue_free()
		return

	await get_tree().create_timer(0.1).timeout

	if is_instance_valid(animated_sprite_2d):
		animated_sprite_2d.modulate = original_modulate
