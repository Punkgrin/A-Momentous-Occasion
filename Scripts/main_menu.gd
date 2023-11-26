extends CanvasLayer

@export var test_scene : PackedScene

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$AudioStreamPlayer.play(Player.menu_music_playback)

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	Player.menu_music_playback = 0.0

func _on_testing_pressed():
	get_tree().change_scene_to_file("res://Scenes/testing.tscn")
	Player.menu_music_playback = 0.0

func _on_options_pressed():
	get_tree().change_scene_to_file("res://Scenes/options.tscn")
	Player.menu_music_playback = $AudioStreamPlayer.get_playback_position()

func _on_quit_to_desktop_pressed():
	get_tree().quit()

