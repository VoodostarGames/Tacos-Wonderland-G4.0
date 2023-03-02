extends Node2D

var cursor = preload("res://Sprites/UI Sprites/menumouse.png")

func _input(event):
	if event is InputEventMouse:
		if get_viewport().get_mouse_position().x >= 0 and get_viewport().get_mouse_position().x <= get_viewport().get_size().x:
			Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW, Vector2(16, 16))
		else:
			Input.set_custom_mouse_cursor(null)

func _on_start_game_pressed():
	get_tree().paused = false
	var _temp = get_tree().change_scene_to_file("res://Scenes/World.tscn")

func _on_game_settings_pressed():
	pass 

func _on_quit_game_pressed():
	get_tree().quit()
