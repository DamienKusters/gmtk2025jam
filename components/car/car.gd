extends PathFollow2D
class_name Car

@onready var game: Game = get_tree().get_current_scene()
@onready var path: Path2D

const MOVE_SPEED: float = .1
const WIDTH_OFFSET: float = 40
const HOLE_SPAWN_CHANCE = .1 #10%

var width_offset: float = 40.0  # Allow changing later
var time_accum: float = 0.0     # For smooth motion based on time

func _process(delta: float) -> void:
	progress_ratio += fposmod(MOVE_SPEED * delta, 1.0)
	
	# AI poc
	time_accum += delta
	var y_offset := sin(time_accum * 2.0) * WIDTH_OFFSET
	$Body.position.y = y_offset

func spawn_hole_attempt():
	randomize()
	var result = randf_range(0, 1)
	if result <= HOLE_SPAWN_CHANCE:
		spawn_hole()

func spawn_hole():
	var i = game.get_hole_instance()
	i.position = position
	game.add_hole(i)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.run_over(self)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Hole:
		# TODO damage chance, not always
		area.damage_hole()
