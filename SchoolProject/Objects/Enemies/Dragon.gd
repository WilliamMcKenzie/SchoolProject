extends "res://Objects/Enemies/Enemy.gd"

func _ready():
	speed = 0
	projectile = load("res://Objects/Projectiles/Fireball.tscn")
	maxcooldown = 600
	get_node("sprite").flip_h = false
	
	randomize()
	teleport()
	player = get_parent().get_node("Player")
	get_node("sprite").connect("animation_finished",self,"reset_anim")
	sprite = get_node("sprite")

func teleport():
	print(position)
	if get_node("sprite").flip_h:
		get_node("sprite").flip_h = false
		position = Vector2(1000, 250)
	else:
		position = Vector2(250, 250)
		get_node("sprite").flip_h = true
	print(position)

func _physics_process(delta):
	if get_parent().playerdied == false:
		
		cooldown -= 1
		
		if cooldown <= 0 and position.distance_to(player.position) < 2000 and get_node("sprite").animation != "death":
			get_node("sprite").animation = "attack"
			cooldown = maxcooldown
			
			var proj = projectile.instance()
			proj.caller_name = "Enemy"
			proj.get_node("sprite").flip_h = !sprite.flip_h
			get_parent().add_child(proj)
			if sprite.flip_h:
				proj.position = position + Vector2(100,0)
			else:
				proj.position = position + Vector2(-100,0)
		
		if get_node("Health").value <= 0 and get_node("sprite").animation != "death":
			get_node("sprite").animation = "death"
			yield (get_tree().create_timer(1),"timeout")
			queue_free()
func reset_anim():
	if get_node("sprite").animation == "attack":
		get_node("sprite").animation = "default"
	if get_node("sprite").animation == "death":
		queue_free()
