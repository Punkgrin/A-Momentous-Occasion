extends Node3D

func _process(delta):
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_parallel(true)
	if Player.total_speed >= 30:
		tween.tween_property($LeftDoorHinge, "rotation_degrees", Vector3(0, 80, 0), 0.3)
		tween.tween_property($RightDoorHinge, "rotation_degrees", Vector3(0, -80, 0), 0.3)
	else:
		tween.tween_property($LeftDoorHinge, "rotation_degrees", Vector3.ZERO, 0.2)
		tween.tween_property($RightDoorHinge, "rotation_degrees", Vector3.ZERO, 0.2)
