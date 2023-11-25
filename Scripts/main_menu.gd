extends CanvasLayer

@export var test_scene : PackedScene

func _ready(): Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_testing_pressed():
	get_tree().change_scene_to_file("res://Scenes/testing.tscn")

func _on_options_pressed():
	get_tree().change_scene_to_file("res://Scenes/options.tscn")

func _on_quit_to_desktop_pressed():
	get_tree().quit()

