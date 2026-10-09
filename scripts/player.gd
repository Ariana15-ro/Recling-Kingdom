extends CharacterBody2D

@export var speed: float = 300.0
@export var acceleration: float = 1500.0
@export var jump_velocity: float = -400.0
@export var coyote_time: float = 0.1
@export var jump_buffer_time: float = 0.1
@export var fall_limit_y: float = 900.0

var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0
var spawn_position: Vector2

func _ready() -> void:
	# Guardar la posición inicial global para reaparecer allí si cae.
	spawn_position = global_position

func _physics_process(delta: float) -> void:
	# Gravedad
	if not is_on_floor():
		velocity += get_gravity() * delta
		coyote_timer -= delta
	else:
		coyote_timer = coyote_time

	# Jump buffer: recuerda si presionaste salto poco antes de tocar el suelo
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time
	else:
		jump_buffer_timer -= delta

	# Salto (usando coyote time y buffer)
	if jump_buffer_timer > 0 and coyote_timer > 0:
		velocity.y = jump_velocity
		coyote_timer = 0
		jump_buffer_timer = 0

	# Movimiento horizontal con aceleración suave
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, acceleration * delta)

	move_and_slide()

	if global_position.y > fall_limit_y:
		global_position = spawn_position
		velocity = Vector2.ZERO
