extends CanvasLayer

func _ready(): 
	$AudioStreamPlayer.play(Player.menu_music_playback)

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	Player.menu_music_playback = $AudioStreamPlayer.get_playback_position()
