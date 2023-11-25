extends GridContainer

func _process(delta):
	$XVelocity.text = "X Velocity: " + str(Player.velocity.x)
	$ZVelocity.text = "Z Velocity: " + str(Player.velocity.z)
	$Friction.text = "Friction: " + str(Player.physics.friction)
	$OnTheFloor.text = "On The Floor: " + str(Player.on_the_floor)
	$Direction.text = "Direction: " + str(Player.direction)
	$Speed.text = "Speed: " + str(Player.total_speed)
	$RelativeSpeed.text = "Relative Speed: " + str(Player.relative_speed)
	$LeftWall.text = "Left Wall: " + str(Player.on_left_wall)
	$RightWall.text = "Right Wall: " + str(Player.on_right_wall)
	$WallNormal.text = "Wall Normal: " + str(Player.wall_normal)
