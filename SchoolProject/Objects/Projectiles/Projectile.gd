extends Area2D


var caller_name
var time = 0.5
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered",self,"damage")

func _physics_process(delta):
	time -= delta
	if time <= 0:
		queue_free()

func damage(area):
	if caller_name == "Player" and area.has_method("I_AM_A_ENEMY"):
		area.get_node("Health").value -= 10
	elif caller_name == "Enemy" and not area.has_method("I_AM_A_ENEMY"):
		area.get_node("Health").value -= 1
