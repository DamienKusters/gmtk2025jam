extends CharacterBody2D
class_name Player

signal inventory_repair_packs_updated
signal holes_patched_updated

const MOVE_SPEED: float = 700
const REPAIR_DELAY: float = 1
const INVENTORY_SIZE: int = 4

var alive = true

var focussed_hole: Hole
var holes_patched: int = 0:
	set(value):
		holes_patched = value
		holes_patched_updated.emit(value)

var inventory_repair_packs: int = 3:
	set(value):
		inventory_repair_packs = clampi(value, 0, get_inventory_size())
		inventory_repair_packs_updated.emit(value)

func _ready() -> void:
	inventory_repair_packs = get_inventory_size()

func get_move_speed() -> float:
	return MOVE_SPEED + (280 * Global.player_upgrades.speed)

func get_repair_delay() -> float:
	return REPAIR_DELAY - clampi((.1 * Global.player_upgrades.repair), 0, .7) # TEST CLAMP

func get_inventory_size() -> int:
	return INVENTORY_SIZE + Global.player_upgrades.inventory

func run_over(car: Car):
	if alive == true:
		alive = false
		Global.fail_level()

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

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Hole and inventory_repair_packs != 0:
		focussed_hole = area
		$RepairTimer.start(get_repair_delay())
		$RepairTimerVisualizer.visible = focussed_hole != null
		_animate_progress()
	if area is RestockingPoint:
		inventory_repair_packs = get_inventory_size()

func _on_repair_timer_timeout() -> void:
	$RepairTimerVisualizer.visible = focussed_hole != null
	if focussed_hole == null:
		return
	focussed_hole.repair_hole()
	holes_patched += 1
	$RepairTimerVisualizer.visible = false
	inventory_repair_packs -= 1

var _tween_progress: Tween
func _animate_progress():
	_tween_progress = Global.animate(_tween_progress)
	$RepairTimerVisualizer/TextureProgressBar.value = 0
	_tween_progress.tween_property($RepairTimerVisualizer/TextureProgressBar, "value", 100, get_repair_delay())
