# This code is copy-pasted and modified from Rapid Survival

extends Node
class_name Save

const save_file_location = "user://save.json"

var template = {
	"floats": {
		"cash": 25,
		"speed": 0,
		"repair": 0,
		"inventory": 0,
	},
	"unlocks": {
		"tracks":["tutorial", "loop"],
		#"tracks":["tutorial","loop", "underpass", "highway"],
	},
}

# Contains loaded save file
var cache: Dictionary = {}

func _init():
	load_file()

#region HelperFunctions
func _cache_not_loaded():
	var not_loaded = cache.is_empty()
	if not_loaded:
		push_error('[Save] Attempting to read from cache while it has not been loaded.')
	return not_loaded

func get_float(key: String) -> float:
	if _cache_not_loaded():
		return false
	return cache.floats[key] if cache.floats.has(key) else 0

func set_float(key: String, value: float) -> float:
	if _cache_not_loaded():
		return false
	cache.floats[key] = value
	return true

func get_unlocked_islands() -> Array[String]:
	if _cache_not_loaded():
		return []
	return cache.unlocks.islands if cache.unlocks.has('islands') else []

func has_unlocked_island(key: String) -> bool:
	if _cache_not_loaded():
		return false
	return cache.unlocks.islands.has(key)

func set_unlocked_island(key: String) -> bool:
	if _cache_not_loaded():
		return false
	cache.unlocks.islands.append(key) #TODO: protect with .has() -> []
	return true

func get_unlocked_cartridges() -> Array[String]:
	if _cache_not_loaded():
		return []
	return cache.unlocks.cartridges #TODO: protect with .has() -> []

func has_unlocked_cartridge(key: String) -> bool:
	if _cache_not_loaded():
		return false
	return cache.unlocks.cartridges.has(key)

func get_challenge(key: String) -> bool:
	if _cache_not_loaded():
		return false
	return cache.challenges[key] if cache.challenges.has(key) else false

func set_challenge(key: String, value: bool) -> bool:
	if _cache_not_loaded():
		return false
	cache.challenges[key] = value
	return true
#endregion

func save_file():
	if cache.is_empty():
		return # Saving is never allowed when cache is empty
	_save_to_disk(save_file_location, cache)

func load_file():
	cache = _load_from_disk(save_file_location, template)

func _save_to_disk(location: String, data: Dictionary):
	var file = FileAccess.open(location, FileAccess.WRITE)
	file.store_line(JSON.stringify(data))

var _fallback_data_returned = false # Gross little flag to check if fallback_data is used
func _load_from_disk(location: String, fallback_data: Dictionary) -> Dictionary:
	if !FileAccess.file_exists(location):
		_fallback_data_returned = true
		return fallback_data
	var file = FileAccess.open(location, FileAccess.READ)
	var content = file.get_as_text()
	if content == "":
		_fallback_data_returned = true
		return fallback_data
	#TODO: if this crashes, consider it corrupt.
	return JSON.parse_string(content)
