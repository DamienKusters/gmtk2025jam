extends CharacterBody2D
class_name Player

signal inventory_repair_packs_updated
signal holes_patched_updated

signal focussed_hole_updated # used in this class

const MOVE_SPEED: float = 700
const REPAIR_DELAY: float = 1
const INVENTORY_SIZE: int = 4

var alive = true

var focussed_hole: Hole:
	set(value):
		focussed_hole = value
		focussed_hole_updated.emit(value)

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
	focussed_hole_updated.connect(_switch_hole_focus)

func get_move_speed() -> float:
	return MOVE_SPEED + (280 * Global.player_upgrades.speed)

func get_repair_delay() -> float:
	var decrease = 0
	for upgrade in Global.player_upgrades.repair:
		decrease += .1
	return REPAIR_DELAY - clampf(decrease, 0, .9) # TEST CLAMP

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

func _on_monitor_timer_timeout() -> void:
	_focus_hole()

func _focus_hole():
	var selected_hole: Hole = null
	for area in $Area2D.get_overlapping_areas():
		if area is Hole:
			selected_hole = area
			break
	if focussed_hole != selected_hole:
		focussed_hole = selected_hole

func _mouse_movement(delta: float):
	if !Input.is_action_pressed("mouse_down"):
			return
	var mouse_position = get_global_mouse_position()
	position += position.direction_to(mouse_position) * get_move_speed() * delta
	move_and_slide()

func _switch_hole_focus(hole: Hole):
	$RepairTimerVisualizer.visible = hole != null
	if hole and inventory_repair_packs > 0:
		$RepairTimer.start(get_repair_delay())
		_animate_progress()

func _on_repair_timer_timeout() -> void:
	if focussed_hole == null or inventory_repair_packs <= 0:
		return
	focussed_hole.repair_hole()
	holes_patched += 1
	$RepairTimerVisualizer.visible = false
	inventory_repair_packs -= 1
	focussed_hole = null # Trigger clear

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is RestockingPoint:
		inventory_repair_packs = get_inventory_size()

var _tween_progress: Tween
func _animate_progress():
	_tween_progress = Global.animate(_tween_progress)
	$RepairTimerVisualizer/TextureProgressBar.value = 0
	_tween_progress.tween_property($RepairTimerVisualizer/TextureProgressBar, "value", 100, get_repair_delay())
