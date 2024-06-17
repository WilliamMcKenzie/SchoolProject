extends Area2D

var caller_name
var time = 0.5
var damage = 1
func _ready():
	connect("body_entered",self,"damage")

func _physics_process(delta):
	time -= delta
	if time <= 0:
		queue_free()

func damage(area):
	if area.name != caller_name:
		area.get_node("Health").value -= damage
