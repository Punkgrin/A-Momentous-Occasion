extends CanvasLayer

@export var options : MarginContainer

func _ready(): 
	$MarginContainer/AudioStreamPlayer.play(Player.menu_music_playback)
	load_settings()

func save_settings():
	Player.filter_index = $MarginContainer/VBoxContainer/Filter/OptionButton.get_selected_id()
	Player.window_index = $MarginContainer/VBoxContainer/Window/OptionButton.get_selected_id()
	Player.master_value = $MarginContainer/VBoxContainer/Volume/HBoxContainer/Master.value
	Player.music_value = $MarginContainer/VBoxContainer/Volume/HBoxContainer/Music.value
	Player.sfx_value = $MarginContainer/VBoxContainer/Volume/HBoxContainer/SFX.value
	Player.fov_value = $MarginContainer/VBoxContainer/FOV/HBoxContainer/FieldOfView.value

func load_settings():
	$MarginContainer/VBoxContainer/Filter/OptionButton.select(Player.filter_index)
	$MarginContainer/VBoxContainer/Window/OptionButton.select(Player.window_index)
	$MarginContainer/VBoxContainer/Volume/HBoxContainer/Master.value = Player.master_value
	$MarginContainer/VBoxContainer/Volume/HBoxContainer/Music.value = Player.music_value
	$MarginContainer/VBoxContainer/Volume/HBoxContainer/SFX.value = Player.sfx_value
	$MarginContainer/VBoxContainer/FOV/HBoxContainer/FieldOfView.value = Player.fov_value

func _on_filter_selected(index):
	match index:
		0:
			Player.material = preload("res://Effects/naughts.tres")
			Player.visible = true
		1:
			Player.material = preload("res://Effects/unplayable.tres")
			Player.visible = true
		2:
			Player.visible = false

func _on_window_selected(index):
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_field_of_view_value_changed(value):
	$MarginContainer/VBoxContainer/FOV/HBoxContainer/Label.text = "      " + str(int(value)) + "      "
	Player.field_of_view = int(value)

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	Player.menu_music_playback = $MarginContainer/AudioStreamPlayer.get_playback_position()
	save_settings()
