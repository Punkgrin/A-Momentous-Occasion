extends RigidBody3D

const player = true
const max_speed = 10
const air_accel = 0.3
const walk = 8.0
const sprint = 12.0
const jump = 6
const sensitivity = 0.004
const blundergust_power = 300.0

# Headbob variables that I "borrowed"
const bob_frequency = 1.5
const bob_amp = 0.08
var t_bob = 0.0

# Also "borrowed" (shoutout to LegionGames for the amazing first person controller tutorial)
const base_fov = 90
const fov_change = 1.1

var raw_input_dir
var input_dir
var direction
var on_the_floor
var on_right_wall
var on_left_wall
var speed
var relative_speed

var gravity = 9.8
var double_jump = 0

@onready var head = $PitchPivot
@onready var camera = $PitchPivot/Camera3D

@export var physics : PhysicsMaterial
@export var steam_scene : PackedScene
@export var jump_effect_scene : PackedScene

# Captures the mouse
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
# Camera Movement
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * sensitivity)
		camera.rotate_x(-event.relative.y * sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-70), deg_to_rad(70))

func _physics_process(delta):
	# Knockoff is_on_floor() but for rigidbodies
	on_the_floor = $CollisionShape3D/FloorCheck.is_colliding()
	# Gets the input direction and handles the movement/deceleration.
	input_dir = Input.get_vector("Left", "Right", "Forward", "Back")
	raw_input_dir = Vector3(input_dir.x, 0, input_dir.y)
	direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	relative_speed = head.transform.basis * linear_velocity
	# Restores double jump
	if on_the_floor:
		double_jump = 2
	# Changes the WallCheck ShapeCasts to rotate based upon camera rotation because around these parts we like hacky solutions
	$CollisionShape3D/LeftWallCheck.rotation.y = $PitchPivot.rotation.y
	$CollisionShape3D/RightWallCheck.rotation.y = $PitchPivot.rotation.y
	# Jumping and jump effects
	if Input.is_action_just_pressed("Jump") && on_the_floor || Input.is_action_just_pressed("Jump") && double_jump > 0:
		var jump_effect = jump_effect_scene.instantiate()
		jump_effect.position.y -= 0.5
		jump_effect.emitting = true
		add_child(jump_effect)
		linear_velocity.y =	jump
		double_jump -= 1
		if !on_the_floor:
			double_jump -= 2
	# Sprinting
	if Input.is_action_pressed("Sprint"):
		speed = sprint
	else:
		speed = walk
	# Sliding and stuff
	if Input.is_action_pressed("Crouch"):
		$CollisionShape3D.scale.y = 0.5
	else:
		$CollisionShape3D.scale.y = 1
	# Firing out steam from the blundergust
	if Input.is_action_just_pressed("Fire") && $BlundergustCooldown.is_stopped():
		var steam = steam_scene.instantiate()
		var firing_vector = $PitchPivot/Camera3D/Blundergust/FirePoint/FireVector.global_position - $PitchPivot/Camera3D/Blundergust/FirePoint.global_position
		steam.position = $PitchPivot/Camera3D/Blundergust/FirePoint.global_position
		steam.rotation = $PitchPivot/Camera3D.global_rotation
		steam.emitting = true
		get_parent().add_child(steam)
		$BlundergustCooldown.start()
		$BlundergustAnimations.current_animation = "fire"
		linear_velocity -= firing_vector * blundergust_power
	$GameplayUI/ProgressBar.set_value($BlundergustCooldown.time_left)
	if on_the_floor:
		if direction:
			linear_velocity.x = direction.x * speed
			linear_velocity.z = direction.z * speed
			physics.friction = 1
		if Input.is_action_pressed("Crouch"):
			physics.friction = 0
		else:
			linear_velocity.x = lerp(linear_velocity.x, direction.x * speed, delta * 50.0)
			linear_velocity.z = lerp(linear_velocity.z, direction.z * speed, delta * 50.0)
			physics.friction = 1
	else:
			if (-relative_speed.x < max_speed && raw_input_dir.x < 0): linear_velocity.x += direction.x * air_accel;
			if (relative_speed.x < max_speed && raw_input_dir.x > 0): linear_velocity.x += direction.x * air_accel;
			if (-relative_speed.z < max_speed && raw_input_dir.z < 0): linear_velocity.z += direction.z * air_accel;
			if (relative_speed.z < max_speed && raw_input_dir.z > 0): linear_velocity.z += direction.z * air_accel;
	# Headbob
	t_bob += delta * linear_velocity.length() * float(on_the_floor)
	camera.transform.origin = _headbob(t_bob)
	# FOV change
	var velocity_clamped = clamp(linear_velocity.length(), 0.5, sprint * 2)
	var target_fov = base_fov + fov_change * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * bob_frequency) * bob_amp
	pos.x = cos(time * bob_frequency / 2) * bob_amp
	return pos
