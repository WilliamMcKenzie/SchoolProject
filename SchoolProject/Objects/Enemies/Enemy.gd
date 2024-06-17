extends KinematicBody2D
var destination
var speed = 100
var velocity
var player
var maxcooldown = 100
var cooldown = maxcooldown
var projectile = load("res://Objects/Projectiles/Projectile.tscn")
var sprite

func _ready():
	randomize()
	player = get_parent().get_node("Player")
	get_node("sprite").connect("animation_finished",self,"reset_anim")
	sprite = get_node("sprite")
func _physics_process(delta):
	if get_parent().playerdied == false:
		var y_move = sin(position.angle_to_point(player.position)) * speed
		var x_move = cos(position.angle_to_point(player.position)) * speed
		velocity = Vector2(-x_move,-y_move)
		
		cooldown -= 1

		if get_node("sprite").animation != "attack" and get_node("sprite").animation != "death" :
			if position.distance_to(player.position) > 125:
				get_node("sprite").animation = "walk"
				move_and_slide(velocity)
			else:
				get_node("sprite").animation = "default"
		if cooldown <= 0 and position.distance_to(player.position) < 125 and get_node("sprite").animation != "death":
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
		
		if x_move <= 0:
			get_node("sprite").flip_h = true
		else:
			get_node("sprite").flip_h = false
		
		if get_node("Health").value <= 0 and get_node("sprite").animation != "death":
			get_node("sprite").animation = "death"
			yield (get_tree().create_timer(1),"timeout")
			queue_free()
func reset_anim():
	if get_node("sprite").animation == "attack":
		get_node("sprite").animation = "default"
	if get_node("sprite").animation == "death":
		queue_free()

func I_AM_A_ENEMY():
	pass
