extends Node2D

func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_PAUSABLE

func _input(event):
	if Input.is_action_pressed("ui_cancel"):
		process_mode = Node.PROCESS_MODE_WHEN_PAUSED
		toggle_pause()

func toggle_pause() -> void:
	#var paused := get_tree().paused
	#if paused == true:
		#paused = false
	#else:
		#paused = true
	get_tree().paused = true
	visible = true

func _on_texture_button_2_button_up() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")


func _on_texture_button_button_up() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	get_tree().paused = false
	visible = false
