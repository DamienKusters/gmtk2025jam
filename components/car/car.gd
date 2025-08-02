extends PathFollow2D
class_name Car

signal laps_completed_updated

@onready var path: Path2D

@export var racetrack: Racetrack # filled by Racetrack scene
@export var texture: Texture2D

# const changed to vars to allow editing difficulty
var MIN_SPEED: float = .07
var MAX_SPEED: float = .13

var WIDTH_OFFSET: float = 110 # still looks ok with 210
var HOLE_SPAWN_CHANCE = .03 #3%
var HOLE_DAMAGE_CHANCE = .3 #30%
var HOLE_CRASH_CHANCE = .05 #5%
const TWEEN_SPEED = 1.5

var move_speed: float = 0
var width_offset: float = 50.0  # Allow changing later
var time_accum: float = 0.0     # For smooth motion based on time
var crashed: bool = false
var laps_completed: int = 0:
	set(value):
		laps_completed = value
		laps_completed_updated.emit(value)

func get_width_offset() -> float:
	return WIDTH_OFFSET

func _ready():
	$DifficultyScaler.scale_difficulty(self, racetrack.car_difficulty)
	$Body/Sprite2D.texture = texture

var _previous_progress_ratio = 0
func _process(delta: float) -> void:
	progress_ratio += fposmod(move_speed * delta, 1.0)
	if progress_ratio < _previous_progress_ratio:
		laps_completed += 1
	_previous_progress_ratio = progress_ratio

func spawn_hole_attempt():
	if crashed:
		return
	randomize()
	if randf_range(0, 1) <= HOLE_SPAWN_CHANCE:
		spawn_hole()

var last_spawned_hole: Hole
func spawn_hole():
	var i = Global.get_hole_instance()
	last_spawned_hole = i
	i.position = $Body.global_position
	racetrack.add_hole(i)

func update_behaviour(stop_car = false):
	if crashed:
		return
	if stop_car: # TODO BROKEN
		_animate_behaviour(0, 0)
		return
	randomize()
	var speed = randf_range(MIN_SPEED, MAX_SPEED)
	var offset = randf_range(WIDTH_OFFSET * -1, WIDTH_OFFSET)
	_animate_behaviour(speed, offset)

var _tween_behaviour: Tween
func _animate_behaviour(speed: float, offset: float):
	_tween_behaviour = Global.animate(_tween_behaviour)
	_tween_behaviour.tween_property(self, "move_speed", speed, TWEEN_SPEED)
	_tween_behaviour.tween_property($Body, "position", Vector2(0, offset), TWEEN_SPEED)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.run_over(self)

func _crash():
	crashed = true
	Global.update_ui_expected_earnings.emit()
	var expl = Global.get_car_explosion_instance()
	expl.position = $Body.global_position
	get_parent().get_parent().add_child(expl)
	call_deferred("queue_free")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Hole and area != last_spawned_hole:
		randomize()
		if area.hole_is_max_size() and randf_range(0, 1) <= HOLE_CRASH_CHANCE:
			_crash()
			return
		if randf_range(0, 1) <= HOLE_DAMAGE_CHANCE:
			area.damage_hole()
