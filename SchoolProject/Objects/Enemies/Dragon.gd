extends KinematicBody2D
var destination
var speed = 100
var velocity
var player
var maxcooldown = 600
var cooldown = maxcooldown
var projectile = load("res://Objects/Projectiles/Fireball.tscn")
var sprite

var weapon_upgrade = preload("res://Objects/Pickups/WeaponUpgrade.tscn")
var teleport_pos = 0
var teleport_cooldown = false
var attack_phase = 0

func _ready():
	speed = 0
	get_node("AttackTimer").max_value = maxcooldown
	teleport()
	
	randomize()
	player = get_parent().get_node("Player")
	get_node("sprite").connect("animation_finished",self,"reset_anim")
	sprite = get_node("sprite")

func teleport():
	if teleport_pos == 1:
		get_node("sprite").flip_h = false
		position = Vector2(905, 250)
		teleport_pos = 0
	else:
		position = Vector2(105, 250)
		get_node("sprite").flip_h = true
		teleport_pos = 1

func _physics_process(delta):
	if get_parent().playerdied == false:
		cooldown -= 1
		
		get_node("AttackTimer").value = cooldown
		
		if attack_phase == 2 and teleport_cooldown == false:
			teleport()
			teleport_cooldown = true
		var health = get_node("Health").value
		var max_health = get_node("Health").max_value
		
		if health <= max_health / 2 and maxcooldown != 60:
			maxcooldown = 60
			cooldown = maxcooldown
			get_node("AttackTimer").max_value = maxcooldown
			get_node("AttackTimer").value = cooldown 
			var custom_theme = load("res://Assets/RedBar.tres")
			get_node("AttackTimer").theme = custom_theme
		
		if cooldown <= 0 and position.distance_to(player.position) < 2000 and get_node("sprite").animation != "death":
			get_node("sprite").animation = "attack"
			cooldown = maxcooldown
			
			var speed = 5
			
			if health <= max_health / 2:
				speed = 6
				maxcooldown = 100
			
			if attack_phase == 0:
				attack_phase = 1
				spawn_projectile(100, speed)
				spawn_projectile(-100, speed)
			elif attack_phase == 1:
				attack_phase =2
				spawn_projectile(0, speed)
			elif attack_phase == 2:
				teleport_cooldown = false
				attack_phase =0
				spawn_projectile(0, speed)
				spawn_projectile(100, speed)
				spawn_projectile(-100, speed)
		
		if get_node("Health").value <= 0 and get_node("sprite").animation != "death":
			get_node("sprite").animation = "death"
			yield (get_tree().create_timer(1),"timeout")
			var weapon_insance = weapon_upgrade.instance()
			get_parent().add_child(weapon_insance)
			weapon_insance.position = self.position
			queue_free()
func reset_anim():
	if get_node("sprite").animation == "attack":
		get_node("sprite").animation = "default"
	if get_node("sprite").animation == "death":
		queue_free()

func spawn_projectile(offset, speed):
	var proj = projectile.instance()
	proj.caller_name = "Enemy"
	proj.target_name = "Player"
	proj.speed = speed
	get_parent().add_child(proj)
	if sprite.flip_h:
		proj.position = position + Vector2(100,offset)
	else:
		proj.position = position + Vector2(-100,offset)

func I_AM_A_ENEMY():
	pass
