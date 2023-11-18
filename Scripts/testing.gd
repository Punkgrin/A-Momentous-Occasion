extends Node3D
func _ready():
	$SplashScreen.current_animation = "splash_screen"
func _process(delta):
	$Player/GameplayUI/Debug/XVelocity.text = "X Velocity: " + str($Player.velocity.x)
	$Player/GameplayUI/Debug/ZVelocity.text = "Z Velocity: " + str($Player.velocity.z)
	$Player/GameplayUI/Debug/Friction.text = "Friction: " + str($Player.physics.friction)
	$Player/GameplayUI/Debug/OnTheFloor.text = "On The Floor: " + str($Player.is_on_floor())
	$Player/GameplayUI/Debug/Direction.text = "Direction: " + str($Player.direction)
	$Player/GameplayUI/Debug/Speed.text = "Speed: " + str($Player.velocity.length())
	$Player/GameplayUI/Debug/RelativeSpeed.text = "Relative Speed: " + str($Player.relative_speed)
	$Player/GameplayUI/Debug/LeftWall.text = "Left Wall: " + str($Player/CollisionShape3D/LeftWallCheck.is_colliding())
	$Player/GameplayUI/Debug/RightWall.text = "Right Wall: " + str($Player/CollisionShape3D/RightWallCheck.is_colliding())
	
