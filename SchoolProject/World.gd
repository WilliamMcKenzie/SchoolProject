extends Node2D

var weapon_cooldown = 15
var weapon_max_cooldown = 15
var weapons_recieved = 1
var weapon_upgrade = preload("res://Objects/Pickups/WeaponUpgrade.tscn")

var enemy = preload("res://Objects/Enemies/Enemy.tscn")
var knight = preload("res://Objects/Enemies/K-night.tscn")
var dragon = preload("res://Objects/Enemies/Dragon.tscn")
var nodes = {
	"Enemy" : enemy,
	"Knight" : knight,
	"Dragon" : dragon,
}

var maxcooldowns = {
	"Enemy" : 8,
	"Knight" : 18,
	"Dragon" : 9999,
}

var cooldowns = {
	"Enemy" : 0,
	"Knight" : 0,
	"Dragon" : 0,
}

var playerdied = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function bod
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	weapon_cooldown -= delta
	if playerdied:
		return
	if weapon_cooldown <= 0 and weapons_recieved <= 2:
		weapon_cooldown = weapon_max_cooldown
		weapons_recieved += 1
		
		var upgrade_instance = weapon_upgrade.instance()
		add_child(upgrade_instance)
		upgrade_instance.position = Vector2(rand_range(1,500),rand_range(1,500))
	for enemy_type in nodes.keys():
		var enemy_node = nodes[enemy_type]
		cooldowns[enemy_type] -= delta
		if cooldowns[enemy_type] <= 0:
			cooldowns[enemy_type] = maxcooldowns[enemy_type]
			var enemy_instance = enemy_node.instance()
			if enemy_type == "Knight":
				enemy_instance.speed = 50
			add_child(enemy_instance)
			
			if enemy_type != "Dragon":
				enemy_instance.position = Vector2(rand_range(1,500),rand_range(1,500))
