extends Area3D

@export var boost_power : int = 150

var blundergust = false

func _on_body_entered(body):
	var boost_vector = $BoostVector.global_position - global_position
	body.velocity += boost_vector * boost_power
