extends Node

class_name RandomUtil

static var rng := RandomNumberGenerator.new()

static func get_random_number(upper_limit: int) -> int:
	return rng.randi() % upper_limit
