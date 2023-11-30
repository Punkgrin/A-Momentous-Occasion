extends CharacterBody3D

@export var movement_vector = Vector3(0, 1, 0)
@export var movement_speed = 1

@onready var initial_position = position + movement_vector

var time = 0.0

func _process(delta):
	time += delta * movement_speed
	position = initial_position + (movement_vector * sin(0.1 * time))
