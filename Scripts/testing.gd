extends Node3D
func _ready():
	$SplashScreen.current_animation = "splash_screen"
func _process(delta):
	$Player/GameplayUI/Debug/XVelocity.text = "X Velocity: " + str($Player.linear_velocity.x)
	$Player/GameplayUI/Debug/ZVelocity.text = "Z Velocity: " + str($Player.linear_velocity.z)
	$Player/GameplayUI/Debug/Friction.text = "Friction: " + str($Player.physics.friction)
	$Player/GameplayUI/Debug/OnTheFloor.text = "On The Floor: " + str($Player.on_the_floor)
	$Player/GameplayUI/Debug/LeftWall.text = "Left Wall: " + str($Player/PitchPivot/LeftWallCheck.is_colliding())
	$Player/GameplayUI/Debug/RightWall.text = "Right Wall: " + str($Player/PitchPivot/RightWallCheck.is_colliding())
	
