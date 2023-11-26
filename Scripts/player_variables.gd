extends Node

var physics : PhysicsMaterial = preload("res://Scenes/physics.tres")
var velocity = Vector3.ZERO
var input_dir
var direction
var wall_normal
var on_the_floor
var on_right_wall
var on_left_wall
var relative_speed
var total_speed = 0.0

var menu_music_playback = 0.0

