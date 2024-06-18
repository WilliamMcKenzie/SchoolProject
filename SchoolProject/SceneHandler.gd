extends Node

var world_instance = preload("res://World.tscn")
var restart_instance = preload("res://ResetMenu.tscn")

func ResetMenu():
	remove_child(get_node("World"))
	add_child(restart_instance.instance())
	
func StartGame():
	remove_child(get_node("ResetMenu"))
	add_child(world_instance.instance())
