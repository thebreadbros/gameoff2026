extends Node2D

var dani_class = preload("res://resources/classes/dani.tres")
var eddy_class = preload("res://resources/classes/eddy.tres")
var henry_class = preload("res://resources/classes/henry.tres")
var michael_class = preload("res://resources/classes/michael.tres")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_texture_button_button_up() -> void:
	Global.player_class = dani_class
	get_tree().change_scene_to_file("res://scenes/red.tscn")


func _on_texture_button_2_button_up() -> void:
	Global.player_class = eddy_class
	get_tree().change_scene_to_file("res://scenes/red.tscn")


func _on_texture_button_3_button_up() -> void:
	Global.player_class = henry_class
	get_tree().change_scene_to_file("res://scenes/red.tscn")


func _on_texture_button_4_button_up() -> void:
	Global.player_class = michael_class
	get_tree().change_scene_to_file("res://scenes/red.tscn")
