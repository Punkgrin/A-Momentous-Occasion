extends CanvasLayer

func _ready(): $AnimationPlayer.current_animation = "intro"
func _on_timer_timeout(): get_tree().change_scene_to_packed(preload("res://Scenes/menu.tscn"))
