extends GPUParticles3D

func _process(delta):
	if emitting == false:
		queue_free()
