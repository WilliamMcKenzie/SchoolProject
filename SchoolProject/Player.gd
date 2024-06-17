extends KinematicBody2D

var speed = 400
var base_cooldown = 30
var cooldown = 0

var projectile = load("res://Objects/Projectiles/Projectile.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("sprite").connect("animation_finished",self,"reset_anim")

func reset_anim():
	if get_node("sprite").animation == "attack":
		get_node("sprite").animation = "default"
	if get_node("sprite").animation == "death":
		get_parent().playerdied = true
		queue_free()
func _physics_process(delta):
	
	
	if cooldown > 0:
		cooldown -= 1
	var move_direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	var velocity = move_direction * speed
	var sprite = get_node("sprite")
	velocity = move_and_slide(velocity)
	
	if velocity == Vector2.ZERO and sprite.animation != "attack" and sprite.animation != "death":
		sprite.animation = "default"
	elif sprite.animation != "attack" and sprite.animation != "death":
		sprite.animation = "walk"
	if move_direction.x > 0:
		sprite.flip_h = true
	if move_direction.x < 0:
		sprite.flip_h = false
		
	if Input.is_action_pressed("click") and sprite.animation != "death":
		if cooldown == 0:
			sprite.animation = "attack"
			cooldown = base_cooldown
			var proj = projectile.instance()
			proj.caller_name = "Player"
			proj.get_node("sprite").flip_h = !sprite.flip_h
			get_parent().add_child(proj)
			if sprite.flip_h:
				proj.position = position + Vector2(100,0)
			else:
				proj.position = position + Vector2(-100,0)
	
	if get_node("Health").value <= 0 and get_node("sprite").animation != "death":
		get_node("sprite").animation = "death"	
			
