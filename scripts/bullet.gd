
extends Area2D

@export var speed: float = 700.0
@export var damage: int = 25

var direction: Vector2 = Vector2.RIGHT


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)


func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta


func set_direction(new_direction: Vector2) -> void:
	direction = new_direction.normalized()
	rotation = direction.angle()


func _on_body_entered(body: Node2D) -> void:

	
	if body.has_method("take_damage"):
		body.take_damage(damage)
	
	queue_free()


func _on_area_entered(area: Area2D) -> void:

	
	var zombie = area
	
	if not zombie.has_method("take_damage"):
		zombie = area.get_parent()
	
	if zombie.has_method("take_damage"):
		zombie.take_damage(damage)
	
	queue_free()
