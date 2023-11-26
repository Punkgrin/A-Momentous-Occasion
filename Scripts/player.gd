extends CharacterBody3D

const player = true
const max_speed = 10
const air_accel = 15
const wall_magnetism = 10
const walk = 5.0
const sprint = 8.0
const jump = 6
const sensitivity = 0.004
const blundergust_power = 300.0

# Headbob variables that I "borrowed"
const bob_frequency = 2
const bob_amplitude = 0.1
var t_bob = 0.0

# Also "borrowed" (shoutout to LegionGames for the amazing first person controller tutorial)
const base_fov = 90
const fov_change = 1.1

var input_dir
var direction
var wall_normal
var on_right_wall
var on_left_wall
var relative_speed
var total_speed
var speed

var gravity = 9.8
var double_jump = 0

@onready var head = $PitchPivot
@onready var camera = $PitchPivot/RollPivot/Camera3D

@export var blundergust : StandardMaterial3D
@export var wind : ParticleProcessMaterial
@export var physics : PhysicsMaterial
@export var steam_scene : PackedScene
@export var jump_effect_scene : PackedScene

# Captures the mouse
func _ready(): Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
# Camera Movement
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * sensitivity)
		camera.rotate_x(-event.relative.y * sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta):
	# Gets the input direction and handles the movement/deceleration.
	input_dir = Input.get_vector("Left", "Right", "Forward", "Back")
	direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	relative_speed = head.transform.basis * Vector3(velocity.x, 0, velocity.z)
	total_speed = Vector3(velocity.x, 0, velocity.z).length()
	
	# Updating all the global variables because I am a lazy boi (and idk how to do global variables in godot)
	Player.velocity = velocity
	Player.on_the_floor = is_on_floor()
	Player.input_dir = input_dir
	Player.direction = direction
	Player.wall_normal = wall_normal
	Player.on_right_wall = on_right_wall
	Player.on_left_wall = on_left_wall
	Player.relative_speed = relative_speed
	Player.total_speed = total_speed

	# Wind (wow)
	if velocity:
		$Wind.volume_db = -70 + 5 * sqrt(total_speed)
		$PitchPivot/RollPivot/Camera3D/Wind.speed_scale = 1 + sqrt(total_speed) / 10
		$PitchPivot/RollPivot/Camera3D/Wind.amount = 10 + int(sqrt(total_speed) * 1.5)
		if (total_speed >= 15):
			wind.scale_min = sqrt(total_speed) / 500 - 0.001
			wind.scale_max = sqrt(total_speed) / 500 - 0.001
		else:
			wind.scale_min = 0
			wind.scale_max = 0

	# Jumping and jump effects
	if Input.is_action_just_pressed("Jump") && is_on_floor() || Input.is_action_just_pressed("Jump") && double_jump > 0:
		var jump_effect = jump_effect_scene.instantiate()
		jump_effect.position.y -= 0.5
		jump_effect.emitting = true
		add_child(jump_effect)
		$Jump.play()
		velocity.y = jump
		double_jump -= 1
		if !is_on_floor():
			double_jump -= 2

	# Sprinting
	if Input.is_action_pressed("Sprint"):
		speed = sprint
		$Step.pitch_scale = 1.2
	else:
		speed = walk
		$Step.pitch_scale = 0.7

	# Sliding and stuff
	if Input.is_action_pressed("Crouch"):
		$CollisionShape3D.scale.y = 0.5
	else:
		$CollisionShape3D.scale.y = 1

	# Firing out steam from the blundergust
	if Input.is_action_just_pressed("Fire") && $BlundergustCooldown.is_stopped():
		var color_tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
		var steam = steam_scene.instantiate()
		var firing_vector = $PitchPivot/RollPivot/Camera3D/Blundergust/FirePoint/FireVector.global_position - $PitchPivot/RollPivot/Camera3D/Blundergust/FirePoint.global_position
		steam.position = $PitchPivot/RollPivot/Camera3D/Blundergust/FirePoint.global_position
		steam.rotation = $PitchPivot/RollPivot/Camera3D.global_rotation
		steam.emitting = true
		get_parent().add_child(steam)
		$BlundergustCooldown.start()
		$BlundergustAnimations.current_animation = "fire"
		$Fire.play()
		velocity -= firing_vector * blundergust_power
		blundergust.albedo_color = Color.RED
		color_tween.tween_property(blundergust, "albedo_color", Color.WHITE, 10)
	# Adding fancy-shmancy UI for overheat
	$GameplayUI/ProgressBar.set_value($BlundergustCooldown.time_left)

	# Wallrunning variables
	on_left_wall = $PitchPivot/LeftWallCheck.is_colliding()
	on_right_wall = $PitchPivot/RightWallCheck.is_colliding()
	if (on_left_wall): wall_normal = $PitchPivot/LeftWallCheck.get_collision_normal();
	if (on_right_wall): wall_normal = $PitchPivot/RightWallCheck.get_collision_normal();

	# WALLRUNNING!!! (sort of)
	var angle_tween = get_tree().create_tween()
	if ((is_on_wall_only()) && input_dir.y < 0 && !is_on_floor()):
		if on_left_wall: angle_tween.tween_property($PitchPivot/RollPivot, "rotation_degrees", Vector3(0, 0, -20), 1);
		if on_right_wall: angle_tween.tween_property($PitchPivot/RollPivot, "rotation_degrees", Vector3(0, 0, 20), 1);
		if (Input.is_action_just_pressed("Jump")): velocity += (wall_normal * jump * 1.5) + (Vector3.UP * jump / 2)
		velocity.y -= gravity * delta / 3
		velocity -= wall_normal * wall_magnetism * delta
		double_jump = 2
		direction.x = 0
	# Quick gravity cameo
	elif !is_on_floor():
		if ($PitchPivot/RollPivot.rotation_degrees.z != 0): angle_tween.tween_property($PitchPivot/RollPivot, "rotation_degrees", Vector3.ZERO, 0.5);
		velocity.y -= gravity * delta
	else:
		if ($PitchPivot/RollPivot.rotation_degrees.z != 0): angle_tween.tween_property($PitchPivot/RollPivot, "rotation_degrees", Vector3.ZERO, 0.5);

	# Various movements
	if is_on_floor():
		if direction && !Input.is_action_pressed("Crouch"):
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
			physics.friction = 1
			$Slide.stop()
			$Step.play($Step.get_playback_position())
		elif velocity && Input.is_action_pressed("Crouch"):
			physics.friction = 0.5
			$Slide.play($Slide.get_playback_position())
			$Step.stop()
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 50.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 50.0)
			physics.friction = 1
			$Slide.stop()
			$Step.stop()
		double_jump = 2
	else:
	# No more airstrafing, but kinda like source I guess.
		if (velocity.x <= 0 && -velocity.x <= max_speed || velocity.x <= 0 && velocity.x * direction.x < 0): velocity.x += direction.x * air_accel * delta;
		if (velocity.z <= 0 && -velocity.z <= max_speed || velocity.z <= 0 && velocity.z * direction.z < 0): velocity.z += direction.z * air_accel * delta;
		if (velocity.x >= 0 && velocity.x <= max_speed || velocity.x >= 0 && velocity.x * direction.x < 0): velocity.x += direction.x * air_accel * delta;
		if (velocity.z >= 0 && velocity.z <= max_speed || velocity.z >= 0 && velocity.z * direction.z < 0): velocity.z += direction.z * air_accel * delta;
		$Slide.stop()
		$Step.stop()

	# Headbob
	t_bob += delta * velocity.length() * float(is_on_floor()) * float(!Input.is_action_pressed("Crouch"))
	camera.transform.origin = _headbob(t_bob)
	# FOV change
	var velocity_clamped = clamp(velocity.length(), 0.5, sprint * 2)
	var target_fov = base_fov + fov_change * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	
	# Menu && Debug
	if Input.is_action_just_pressed("Quit"): get_tree().change_scene_to_file("res://Scenes/menu.tscn");
	if Input.is_action_just_pressed("Debug"):
		if ($GameplayUI/Debug.visible) == true: $GameplayUI/Debug.hide()
		else: $GameplayUI/Debug.show()

	move_and_slide()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * bob_frequency) * bob_amplitude
	pos.x = cos(time * bob_frequency / 2) * bob_amplitude
	return pos
