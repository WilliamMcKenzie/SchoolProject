extends AnimatedSprite

var time = 1
var cooldown = 1
var debounce = true
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	time -= delta
	if time  <= 0 and debounce == true:
		time = cooldown
		animation = "shine"
		debounce = false

func _on_WeaponUpgrade_animation_finished():
	if animation == "shine":
		animation = "default"
		debounce = true





func _on_Area2D_body_entered(body):
	if body.name == "Player":
		if get_parent().get_node("Player").weapon == "metal":
			get_parent().get_node("Player").get_node("sprite").material.set_shader_param("projnew",Color(0.266113, 0.616589, 0.625,1))
			get_parent().get_node("Player").weapon = "mithril"
			
		elif get_parent().get_node("Player").weapon == "mithril":
			get_parent().get_node("Player").get_node("sprite").material.set_shader_param("projnew",Color(0.422363, 0.219727, 0.625,1))
			get_parent().get_node("Player").weapon = "void"
		elif get_parent().get_node("Player").weapon == "void":
			get_parent().get_node("Player").get_node("sprite").material.set_shader_param("projnew",Color(0.422363, 0.219727, 0.625,1))
			get_parent().get_node("Player").weapon = "dragon"
		queue_free()
			
