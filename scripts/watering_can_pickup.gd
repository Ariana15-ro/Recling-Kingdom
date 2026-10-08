extends Area2D

# Conecta la detección del jugador al entrar en el área.
func _ready() -> void:
	body_entered.connect(_on_body_entered)


# Recoge la regadera solo cuando entra un nodo del grupo "player".
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameState.has_watering_can = true
		print("¡Regadera recogida!")
		queue_free()
