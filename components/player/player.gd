extends CharacterBody2D
class_name Player

@onready var game: Game = get_tree().get_current_scene()

signal inventory_repair_packs_updated

const MOVE_SPEED: float = 700
const REPAIR_SPEED: float = 1
const INVENTORY_SIZE: int = 3

var alive = true

var inventory_repair_packs: int = 3:
	set(value):
		inventory_repair_packs = value
		inventory_repair_packs_updated.emit(value)

func _ready() -> void:
	inventory_repair_packs = INVENTORY_SIZE

func get_move_speed() -> float:
	return MOVE_SPEED

func get_repair_speed() -> float:
	return REPAIR_SPEED

func get_inventory_size() -> int:
	return INVENTORY_SIZE

func run_over(car: Car):
	alive = false
	game.fail_level.emit()

func _process(delta: float) -> void:
	if !alive:
		return
	_mouse_movement(delta)
	
func _mouse_movement(delta: float):
	if !Input.is_action_pressed("mouse_down"):
			return
	var mouse_position = get_global_mouse_position()
	position += position.direction_to(mouse_position) * get_move_speed() * delta
	move_and_slide()
