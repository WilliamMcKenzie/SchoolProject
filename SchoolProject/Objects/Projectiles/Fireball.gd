extends Area2D


var caller_name
var target_name
var time = 5
var speed = 8
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered",self,"damage")

func _physics_process(delta):
	if get_parent().has_node(target_name):
		var target_position = get_parent().get_node(target_name).position
		look_at(target_position)
	
		var y_move = -sin(position.angle_to_point(target_position)) * speed
		var x_move = -cos(position.angle_to_point(target_position)) * speed
		var velocity = Vector2(x_move, y_move)
		
		position += velocity
	time -= delta
	if time <= 0:
		queue_free()

func damage(area):
	
	if caller_name == "Player" and area.has_method("I_AM_A_ENEMY") and area.name == "Dragon":
		area.get_node("Health").value -= 0.5
		queue_free()
	elif caller_name == "Enemy" and not area.has_method("I_AM_A_ENEMY") and target_name == "Player":
		area.get_node("Health").value -= 1
		queue_free()


func _on_Fireball_area_entered(area):
	if caller_name == "Enemy" and area.has_method("damage") and area.caller_name == "Player":
		var proj = load("res://Objects/Projectiles/Fireball.tscn").instance()
		proj.caller_name = "Player"
		proj.target_name = "Dragon"
		proj.position = self.position
		get_parent().add_child(proj)
		queue_free()
