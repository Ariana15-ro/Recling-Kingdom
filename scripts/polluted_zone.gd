extends Node2D

# Estado de la zona: true si fue restaurada, false si está contaminada
var is_restored: bool = false

# Color visual cuando la zona está contaminada (configurable desde Inspector)
@export var polluted_color: Color = Color.GRAY

# Color visual cuando la zona ha sido restaurada (configurable desde Inspector)
@export var restored_color: Color = Color.GREEN

# Referencia al Area2D hijo para detectar la presencia del jugador
@onready var interaction_area: Area2D = $InteractionArea

# Referencia a las partículas de restauración
@onready var particles: CPUParticles2D = $CPUParticles2D

# Referencia al mensaje de falta de la regadera
@onready var hint_label: Label = $Label

# Indica si el jugador está dentro del área de interacción
var player_in_range: bool = false


func _ready() -> void:
	# Conectar señales del Area2D para detectar entrada y salida de cuerpos
	interaction_area.body_entered.connect(_on_body_entered)
	interaction_area.body_exited.connect(_on_body_exited)

	# Asegurar que el Polygon2D empiece con el color contaminado
	_update_polygon_color()


# Método público para restaurar la zona: cambia el estado y el color visual
func restore_zone() -> void:
	is_restored = true
	var polygon: Polygon2D = $Polygon2D
	var tween := create_tween()
	tween.tween_property(polygon, "color", restored_color, 1.5)
	particles.restart()
	particles.emitting = true
	hint_label.visible = false


# Actualiza el color del Polygon2D según el estado actual
func _update_polygon_color() -> void:
	var polygon: Polygon2D = $Polygon2D
	if is_restored:
		polygon.color = restored_color
	else:
		polygon.color = polluted_color


# Se ejecuta cuando un cuerpo entra en el Area2D
func _on_body_entered(body: Node2D) -> void:
	# Verificar que el cuerpo sea el jugador (pertenece al grupo "player")
	if body.is_in_group("player"):
		player_in_range = true


# Se ejecuta cuando un cuerpo sale del Area2D
func _on_body_exited(body: Node2D) -> void:
	# Verificar que el cuerpo sea el jugador
	if body.is_in_group("player"):
		player_in_range = false


# Se ejecuta cada frame para detectar la pulsación de la tecla de interacción
func _process(_delta: float) -> void:
	# Si el jugador está en rango, la zona no está restaurada, y presiona interactuar
	if player_in_range and not is_restored and Input.is_action_just_pressed("interact"):
		# Verificar si el jugador tiene la regadera en el estado global
		if GameState.has_watering_can:
			restore_zone()
		else:
			hint_label.visible = true
			await get_tree().create_timer(2.0).timeout
			hint_label.visible = false
