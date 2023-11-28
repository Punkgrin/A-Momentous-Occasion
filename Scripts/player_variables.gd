extends Node

# All of the ACTUAL player variables
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
var field_of_view = 90

# Variables for storing the settings
var filter_index : int
var window_index : int
var resolution_index : int
var master_value = 1
var music_value = 1
var sfx_value = 1
var fov_value = 90
var material : ShaderMaterial = preload("res://Effects/naughts.tres")
var visible = true
# One-off variable for saving the music because idk how
var menu_music_playback = 0.0

