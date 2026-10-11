extends CharacterBody2D
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


const SPEED = 300.0
const JUMP_VELOCITY = -600.0
var alive = true
var health = 3


func _physics_process(delta: float) -> void:   
	if !alive:
		return
	if health <= 0:
		die()
	# Add animation  
	if (velocity.x  > 1 or velocity.x < -1) and is_on_floor() and animated_sprite_2d.animation != "Hit":
		animated_sprite_2d.animation = "Run"
	elif is_on_floor() and animated_sprite_2d.animation != "Hit":
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

	# Get the input direction and handle the movement/deceleration.      
		  
	var direction := Input.get_axis("left", "right")      
	if direction:          
		velocity.x = direction * SPEED      
	else:          velocity.x = move_toward(velocity.x, 0, SPEED)    
  
	move_and_slide()
	if direction == 1.0:
		animated_sprite_2d.flip_h = false
	elif direction == -1.0:
		animated_sprite_2d.flip_h = true
		
func hurt() -> void:
	animated_sprite_2d.animation = "Hit"
	health = health - 1
	
func die() -> void:
	animated_sprite_2d.animation = "Hit"
	alive = false
