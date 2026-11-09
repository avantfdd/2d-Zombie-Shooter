extends CharacterBody2D
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const BULLET_SCENE = preload("res://scenes/bullet.tscn")
const SPEED = 300.0
const JUMP_VELOCITY = -600.0
@export var fire_rate: float = 0.25
var facing_direction: float = 1.0
var can_shoot: bool = true
@onready var gun_point: Marker2D = $GunPoint
@export var gun_offset: float = 16.0
var alive = true
var health = 3

func _ready() -> void:
	set_health_bar()
func _physics_process(delta: float) -> void:  
	
	if !alive:
		return
	if health <= 0:
		die()
	# Add animation  
	if (velocity.x  > 1 or velocity.x < -1):
		animated_sprite_2d.animation = "Run"
	elif is_on_floor():
		animated_sprite_2d.animation = "Idle"
		
	# Add the gravity.      
	if not is_on_floor():          
		velocity += get_gravity() * delta  
		if animated_sprite_2d.animation != "Jump":
			animated_sprite_2d.animation = "Jump"    

	# Handle jump.      
	if Input.is_action_just_pressed("jump") and is_on_floor():          
		velocity.y = JUMP_VELOCITY      
		jump_sound.play()
		
	if Input.is_action_just_pressed("reset"):
		reset()
	#Handle shooting
	if Input.is_action_just_pressed("shoot"):
		shoot()
	# Get the input direction and handle the movement/deceleration.      
		  
	var direction := Input.get_axis("left", "right")      
	if direction:          
		velocity.x = direction * SPEED      
	else:          velocity.x = move_toward(velocity.x, 0, SPEED)    
  
	move_and_slide()
	if direction == 1.0:
		animated_sprite_2d.flip_h = false
		update_facing(1.0)
	elif direction == -1.0:
		animated_sprite_2d.flip_h = true
		update_facing(-1.0)
		
func hurt() -> void:
	animated_sprite_2d.animation = "Hit"
	health = health - 1
	$HealthBar.value = health
	
func die() -> void:
	animated_sprite_2d.animation = "Hit"
	alive = false

func set_health_bar() -> void:
	$HealthBar.max_value = health
	$HealthBar.value = health
func reset() -> void:
	get_tree().reload_current_scene()
	
func shoot() -> void:
	if not can_shoot:
		return

	can_shoot = false

	var bullet = BULLET_SCENE.instantiate()
	get_tree().current_scene.add_child(bullet)

	bullet.global_position = gun_point.global_position
	bullet.set_direction(Vector2(facing_direction, 0))

	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true
func update_facing(direction: float) -> void:
	if direction == 0:
		return

	facing_direction = sign(direction)
	gun_point.position.x = abs(gun_offset) * facing_direction
