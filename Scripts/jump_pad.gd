extends Area3D
@export var boost_power = 250
func _on_body_entered(body):
	var boost_vector = $BoostVector.global_position - global_position
	body.linear_velocity += boost_vector * boost_power
