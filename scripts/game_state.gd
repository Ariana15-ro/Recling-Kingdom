extends Node

# Singleton / Autoload global del juego.
# Se accede desde cualquier script como: GameState.has_watering_can

# Indica si el jugador actualmente tiene la regadera en su inventario
var has_watering_can: bool = false

# Diccionario de zonas restauradas (para futuro).
# Clave: nombre/ID de la zona, Valor: true si está restaurada.
# Ejemplo: restored_zones = {"ZonaNorte": true, "ZonaSur": false}
var restored_zones: Dictionary = {}

# Método auxiliar para marcar una zona como restaurada en el diccionario
func mark_zone_restored(zone_id: String) -> void:
	restored_zones[zone_id] = true

# Método auxiliar para consultar si una zona ya fue restaurada
func is_zone_restored(zone_id: String) -> bool:
	return restored_zones.get(zone_id, false)
