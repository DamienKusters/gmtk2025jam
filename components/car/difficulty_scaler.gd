extends Node
class_name DifficultyScaler

# Difficulty 0 = standard
# TEST values
func scale_difficulty(car: Car, difficulty: int):
	difficulty = clampi(difficulty, 0, 100)
	car.MIN_SPEED = .07 + (0.01 * difficulty)
	car.MAX_SPEED = .13 + (0.02 * difficulty)
	#car.WIDTH_OFFSET = 110
	car.HOLE_SPAWN_CHANCE = .03 + (0.01 * difficulty)
	#car.HOLE_DAMAGE_CHANCE = .3 + (0.05 * difficulty) # TOO harsh
	#car.HOLE_CRASH_CHANCE = .05 + (0.01 * difficulty) # TOO harsh
	
