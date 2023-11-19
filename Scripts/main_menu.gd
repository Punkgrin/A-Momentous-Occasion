extends CanvasLayer


func _ready(): Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_testing_pressed():
	var testing = get_parent().test_scene.instantiate()
	get_parent().add_child(testing)
	queue_free()

func _on_options_pressed():
	pass # Replace with function body.

func _on_quit_to_desktop_pressed():
	get_tree().quit()

