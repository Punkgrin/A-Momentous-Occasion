extends Area3D
const boost_power : int = 100
func _on_body_entered(body):
	var boost_vector = $BoostVector.global_position - global_position
	body.velocity += boost_vector * boost_power
