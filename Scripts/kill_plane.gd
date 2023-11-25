extends Area3D

func _on_body_entered(body):
	if body.player == true:
		body.global_position = Vector3.ZERO + Vector3.UP
		body.velocity = Vector3.ZERO
	else:
		body.queue_free()
