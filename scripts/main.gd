extends Node2D

func _ready() -> void:
	_setup_level()

func _setup_level() -> void:
	# Connect enemies
	var enemies = $LevelRoot.get_node_or_null("Enemies")
	if enemies:
		for enemy in enemies.get_children():
			enemy.player_hurt.connect(_on_player_hurt)
			 
			#Signal Handlers
func _on_player_hurt(body):
	body.hurt()
