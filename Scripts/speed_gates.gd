extends Node3D

# The speed that the player needs to reach in order to open the gates
@export var open_speed = 30.0

func _process(delta):
	# Silky smooth tweening for the open and close of the door (idk what im doing)
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_parallel(true)
	if Player.total_speed >= open_speed:
		tween.tween_property($LeftDoorHinge, "rotation_degrees", Vector3(0, 80, 0), 0.3)
		tween.tween_property($RightDoorHinge, "rotation_degrees", Vector3(0, -80, 0), 0.3)
	else:
		tween.tween_property($LeftDoorHinge, "rotation_degrees", Vector3.ZERO, 0.2)
		tween.tween_property($RightDoorHinge, "rotation_degrees", Vector3.ZERO, 0.2)
