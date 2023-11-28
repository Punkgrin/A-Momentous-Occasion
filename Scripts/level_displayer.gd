extends CanvasLayer

@export var text : String

func _ready(): 
	$MarginContainer/RichTextLabel.text = "[wave amp=100.0 freq=10 connected=1]" + text
	$AnimationPlayer.current_animation = "display_level"
