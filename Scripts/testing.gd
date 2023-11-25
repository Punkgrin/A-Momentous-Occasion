extends Node3D

var speed

func _ready():
	$SplashScreen.current_animation = "splash_screen"
func _process(delta):
	speed = (Vector3($Player.velocity.x, 0, $Player.velocity.z)).length()
	$Player/GameplayUI/Debug/XVelocity.text = "X Velocity: " + str($Player.velocity.x)
	$Player/GameplayUI/Debug/ZVelocity.text = "Z Velocity: " + str($Player.velocity.z)
	$Player/GameplayUI/Debug/Friction.text = "Friction: " + str($Player.physics.friction)
	$Player/GameplayUI/Debug/OnTheFloor.text = "On The Floor: " + str($Player.is_on_floor())
	$Player/GameplayUI/Debug/Direction.text = "Direction: " + str($Player.direction)
	$Player/GameplayUI/Debug/Speed.text = "Speed: " + str(speed)
	$Player/GameplayUI/Debug/RelativeSpeed.text = "Relative Speed: " + str($Player.relative_speed)
	$Player/GameplayUI/Debug/LeftWall.text = "Left Wall: " + str($Player/PitchPivot/LeftWallCheck.is_colliding())
	$Player/GameplayUI/Debug/RightWall.text = "Right Wall: " + str($Player/PitchPivot/RightWallCheck.is_colliding())
	$Player/GameplayUI/Debug/WallNormal.text = "Wall Normal: " + str($Player.wall_normal)
