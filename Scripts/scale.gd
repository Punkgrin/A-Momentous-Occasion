extends Area3D
@export var next_stage : PackedScene
func _on_body_entered(body):
	get_tree().change_scene_to_packed(next_stage)
